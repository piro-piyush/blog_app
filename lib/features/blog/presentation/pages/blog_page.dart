import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    _tabController = TabController(
        length: Constants.topics.length + 1, vsync: this); // +1 for "All" tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Blog App',
          style: TextStyle(color: Colors.white), // White title text
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled, color: Colors.white),
          ),
          const SizedBox(width: 20),
        ],
        bottom: TabBar(
          dragStartBehavior: DragStartBehavior.start,
          indicatorPadding: EdgeInsets.zero,
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          tabs: [
            _buildTab('All'), // "All" tab
            for (var topic in Constants.topics) _buildTab(topic),
          ],
        ),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }

          if (state is BlogsDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return _noBlogsMessage();
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildBlogList(state.blogs), // "All" tab
                for (var topic in Constants.topics)
                  _buildBlogList(
                    state.blogs
                        .where((blog) => blog.topics.contains(topic))
                        .toList(),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  // Custom Tab Widget with Padding
  Widget _buildTab(String label) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        // Horizontal padding
        child: Text(
          label,
          style: const TextStyle(fontSize: 16), // Adjust the font size
        ),
      ),
    );
  }

  // Widget to show "No Blogs Yet" message
  Widget _noBlogsMessage() {
    return Center(
      child: Text(
        "No Blogs Yet",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Build the blog list widget with "No Blogs Yet" fallback for empty filtered lists
  Widget _buildBlogList(List<Blog> blogs) {
    if (blogs.isEmpty) {
      return _noBlogsMessage();
    }

    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return BlogCard(
          blog: blog,
          color: index % 2 == 0 ? AppPallete.gradient1 : AppPallete.gradient2,
        );
      },
    );
  }
}
