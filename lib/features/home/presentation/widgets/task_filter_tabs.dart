import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

enum TaskFilter { all, recent, newTask, completed }

class TaskFilterTabs extends StatelessWidget {
  final TaskFilter selectedFilter;
  final Function(TaskFilter) onFilterChanged;

  const TaskFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTab(
            label: 'home.tasks.filter.all'.tr,
            filter: TaskFilter.all,
          ),
          _buildTab(
            label: 'home.tasks.filter.recent'.tr,
            filter: TaskFilter.recent,
          ),
          _buildTab(
            label: 'home.tasks.filter.new'.tr,
            filter: TaskFilter.newTask,
          ),
          _buildTab(
            label: 'home.tasks.filter.completed'.tr,
            filter: TaskFilter.completed,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({required String label, required TaskFilter filter}) {
    final isSelected = selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.grayText,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
