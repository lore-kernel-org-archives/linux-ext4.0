From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/28] ext4: Add new tracepoints to debug delayed allocation space functions
Date: Tue,  2 Mar 2010 13:18:22 -0500
Message-ID: <1267553925-6308-6-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0CBSSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:54 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add tracepoints for ext4_da_reserve_space(),
ext4_da_update_reserve_space(), and ext4_da_release_space().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c             |    2 +
 include/trace/events/ext4.h |  101 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e8afd9..1a3d7b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1061,6 +1061,7 @@ void ext4_da_update_reserve_space(struct inode *inode,
 	int mdb_free = 0, allocated_meta_blocks = 0;
 
 	spin_lock(&ei->i_block_reservation_lock);
+	trace_ext4_da_update_reserve_space(inode, used);
 	if (unlikely(used > ei->i_reserved_data_blocks)) {
 		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
 			 "with only %d reserved data blocks\n",
@@ -1846,6 +1847,7 @@ repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	md_reserved = ei->i_reserved_meta_blocks;
 	md_needed = ext4_calc_metadata_amount(inode, lblock);
+	trace_ext4_da_reserve_space(inode, md_needed);
 	spin_unlock(&ei->i_block_reservation_lock);
 
 	/*
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d0b6cd3..2aa6aa3 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -874,6 +874,107 @@ TRACE_EVENT(ext4_forget,
 		  __entry->mode, __entry->is_metadata, __entry->block)
 );
 
+TRACE_EVENT(ext4_da_update_reserve_space,
+	TP_PROTO(struct inode *inode, int used_blocks),
+
+	TP_ARGS(inode, used_blocks),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	__u64,	i_blocks		)
+		__field(	int,	used_blocks		)
+		__field(	int,	reserved_data_blocks	)
+		__field(	int,	reserved_meta_blocks	)
+		__field(	int,	allocated_meta_blocks	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->i_blocks = inode->i_blocks;
+		__entry->used_blocks = used_blocks;
+		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+		__entry->allocated_meta_blocks = EXT4_I(inode)->i_allocated_meta_blocks;
+	),
+
+	TP_printk("dev %s ino %lu mode 0%o i_blocks %llu used_blocks %d reserved_data_blocks %d reserved_meta_blocks %d allocated_meta_blocks %d",
+		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
+		  __entry->mode,  (unsigned long long) __entry->i_blocks,
+		  __entry->used_blocks, __entry->reserved_data_blocks,
+		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
+);
+
+TRACE_EVENT(ext4_da_reserve_space,
+	TP_PROTO(struct inode *inode, int md_needed),
+
+	TP_ARGS(inode, md_needed),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	__u64,	i_blocks		)
+		__field(	int,	md_needed		)
+		__field(	int,	reserved_data_blocks	)
+		__field(	int,	reserved_meta_blocks	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->i_blocks = inode->i_blocks;
+		__entry->md_needed = md_needed;
+		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+	),
+
+	TP_printk("dev %s ino %lu mode 0%o i_blocks %llu md_needed %d reserved_data_blocks %d reserved_meta_blocks %d",
+		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
+		  __entry->mode, (unsigned long long) __entry->i_blocks,
+		  __entry->md_needed, __entry->reserved_data_blocks,
+		  __entry->reserved_meta_blocks)
+);
+
+TRACE_EVENT(ext4_da_release_space,
+	TP_PROTO(struct inode *inode, int freed_blocks),
+
+	TP_ARGS(inode, freed_blocks),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	__u64,	i_blocks		)
+		__field(	int,	freed_blocks		)
+		__field(	int,	reserved_data_blocks	)
+		__field(	int,	reserved_meta_blocks	)
+		__field(	int,	allocated_meta_blocks	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->i_blocks = inode->i_blocks;
+		__entry->freed_blocks = freed_blocks;
+		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+		__entry->allocated_meta_blocks = EXT4_I(inode)->i_allocated_meta_blocks;
+	),
+
+	TP_printk("dev %s ino %lu mode 0%o i_blocks %llu freed_blocks %d reserved_data_blocks %d reserved_meta_blocks %d allocated_meta_blocks %d",
+		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
+		  __entry->mode, (unsigned long long) __entry->i_blocks,
+		  __entry->freed_blocks, __entry->reserved_data_blocks,
+		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
+);
+
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
1.6.6.1.1.g974db.dirty

