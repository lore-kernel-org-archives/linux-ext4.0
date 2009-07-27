From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Print extent information in debugfs
Date: Sun, 26 Jul 2009 23:02:19 -0400
Message-ID: <20090727030219.GE17272@mit.edu>
References: <6601abe90907231336o64cdc786r634d29be822316af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45166 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbZG0DCZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Jul 2009 23:02:25 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90907231336o64cdc786r634d29be822316af@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 23, 2009 at 01:36:29PM -0700, Curt Wohlgemuth wrote:
> Here's some sample output from the 'stat' command for a ~100MB file (that's
> been fallocate'd and written):
> 
> ===========================================================
> ...
> atime: 0x4a679eb7 -- Wed Jul 22 16:20:23 2009
> mtime: 0x4a68b71f -- Thu Jul 23 12:16:47 2009
> Extents (logical blocks):
> (0-25599), (25600-30719 [uninit]), (30720-61439 [uninit]),
> (61440-63487 [uninit]), (63488-94207 [uninit]), (94208-96255
> [uninit]), (96256-124927 [uninit]), (124928-131071 [uninit])
> BLOCKS:
> (IND):133120, (0-63487):34816-98303, (63488-96255):100352-133119,
> (96256-124927):135168-163839, (124928-131071):165888-172031
> TOTAL: 131073
> ===========================================================

The Extents and Blocks information display redundant information, so
what I've done is to change the patch so that if the file uses
extent-based block maps, the Extents information is displayed instead
of the BLOCKS information, and it is extended to include more
information, like this:

...
 atime: 0x4a6d164e:82c08b38 -- Sun Jul 26 22:51:58 2009
 mtime: 0x4a6d164e:861ee098 -- Sun Jul 26 22:51:58 2009
crtime: 0x4a6d164e:82c08b38 -- Sun Jul 26 22:51:58 2009
Size of extra inode fields: 28
EXTENTS:
(0-60 #61): 342272-342332, (61-127 #67 [uninit]): 537822-537888

I've also added a dump_extents command which displays even more
information for extremely complex extent trees, so that someone
examining a filesystem can display the interior nodes of the extent
tree.

					- Ted

commit ed166f9b449c53bb8df4ec277fa476d62a160367
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 26 22:29:47 2009 -0400

    debugfs: Add the new command dump_extents and extent the stat command
    
    Extend the stat command to display more detailed extent information if
    the file uses extent mapping instead of displaying the block map using
    the block_iterate funtion.
    
    Add the command dump_extents which displays even more detailed
    information about an inode's extent tree.
    
    This commit is an extension of a patch from Curt Wohlgemuth.
    
    Signed-off-by: Curt Wohlgemuth <curtw@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 5355764..95dea0d 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -43,6 +43,9 @@ request do_list_dir, "List directory",
 request do_stat, "Show inode information ",
 	show_inode_info, stat;
 
+request do_dump_extents, "Dump extents information ",
+	dump_extents, extents, ex;
+
 request do_link, "Create directory link",
 	link, ln;
 
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 4dcc48b..a0a2dbd 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -192,6 +192,19 @@ option is given set the owner, group and permissions information on
 to match 
 .IR filespec .
 .TP
+.I dump_extents [-n] [-l] filespec
+Dump the the extent tree of the inode
+.IR filespec .
+The 
+.I -n
+flag will cause
+.I dump_extents
+to only display the interior nodes in the extent tree.   The
+.I  -l
+flag cause
+.I dump_extents
+to only display the leaf nodes in the extent tree.
+.TP
 .I expand_dir filespec
 Expand the directory
 .IR filespec .
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 1710aa2..6d2e853 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -551,6 +551,98 @@ static void dump_blocks(FILE *f, const char *prefix, ext2_ino_t inode)
 	fprintf(f,"\n");
 }
 
+#define DUMP_LEAF_EXTENTS	0x01
+#define DUMP_NODE_EXTENTS	0x02
+#define DUMP_EXTENT_LEVEL	0x04
+#define DUMP_ALL_EXTENTS	0x07
+
+static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
+			 int flags)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	struct ext2_extent_info info;
+	int			op = EXT2_EXTENT_ROOT;
+	unsigned int		printed = 0;
+	errcode_t 		errcode;
+
+	errcode = ext2fs_extent_open(current_fs, ino, &handle);
+	if (errcode)
+		return;
+
+	fprintf(f, "%sEXTENTS:\n%s", prefix, prefix);
+
+	while (1) {
+		errcode = ext2fs_extent_get(handle, op, &extent);
+
+		if (errcode)
+			break;
+
+		op = EXT2_EXTENT_NEXT;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			continue;
+
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
+			if ((flags & DUMP_LEAF_EXTENTS) == 0)
+				continue;
+		} else {
+			if ((flags & DUMP_NODE_EXTENTS) == 0)
+				continue;
+		}
+
+		errcode = ext2fs_extent_get_info(handle, &info);
+		if (errcode)
+			continue;
+		if (info.curr_entry == 1 && (flags & DUMP_EXTENT_LEVEL)) {
+			fprintf(f, "%s[L%d/%d %d/%d] ",
+				printed ? ", " : "",
+				info.curr_level, info.max_depth,
+				info.num_entries, info.max_entries);
+			printed = 0;
+		}
+
+		if (!(extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)) {
+			if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+				continue;
+
+			fprintf(f, "%s(NODE #%d, %lld-%lld #%u, blk %lld)",
+				printed ? ", " : "",
+				info.curr_entry,
+				extent.e_lblk,
+				extent.e_lblk + (extent.e_len - 1),
+				extent.e_len,
+				extent.e_pblk);
+			printed = 1;
+			continue;
+		}
+
+		if (extent.e_len == 0)
+			continue;
+		else if (extent.e_len == 1)
+			fprintf(f,
+				"%s(%lld%s): %lld",
+				printed ? ", " : "",
+				extent.e_lblk,
+				extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
+				" [uninit]" : "",
+				extent.e_pblk);
+		else
+			fprintf(f,
+				"%s(%lld-%lld #%u%s): %lld-%lld",
+				printed ? ", " : "",
+				extent.e_lblk,
+				extent.e_lblk + (extent.e_len - 1),
+				extent.e_len,
+				extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
+					" [uninit]" : "",
+				extent.e_pblk,
+				extent.e_pblk + (extent.e_len - 1));
+		printed = 1;
+	}
+	if (printed)
+		fprintf(f, "\n");
+}
 
 void internal_dump_inode(FILE *out, const char *prefix,
 			 ext2_ino_t inode_num, struct ext2_inode *inode,
@@ -671,9 +763,12 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		}
 		fprintf(out, "%sDevice major/minor number: %02d:%02d (hex %02x:%02x)\n",
 			devnote, major, minor, major, minor);
+	} else if (do_dump_blocks) {
+		if (inode->i_flags & EXT4_EXTENTS_FL)
+			dump_extents(out, prefix, inode_num, DUMP_LEAF_EXTENTS);
+		else
+			dump_blocks(out, prefix, inode_num);
 	}
-	else if (do_dump_blocks)
-		dump_blocks(out, prefix, inode_num);
 }
 
 static void dump_inode(ext2_ino_t inode_num, struct ext2_inode *inode)
@@ -716,6 +811,59 @@ void do_stat(int argc, char *argv[])
 	return;
 }
 
+void do_dump_extents(int argc, char *argv[])
+{
+	struct ext2_inode inode;
+	ext2_ino_t	ino;
+	FILE		*out;
+	int		c, flags = 0;
+
+	reset_getopt();
+	while ((c = getopt(argc, argv, "nl")) != EOF) {
+		switch (c) {
+		case 'n':
+			flags |= DUMP_NODE_EXTENTS;
+			break;
+		case 'l':
+			flags |= DUMP_LEAF_EXTENTS;
+			break;
+		}
+	}
+
+	if (argc != optind+1) {
+	print_usage:
+		com_err(0, 0, "Usage: dump_extents [-n] [-l] file");
+		return;
+	}
+
+	if (flags == 0)
+		flags = DUMP_ALL_EXTENTS;
+	else if (flags == DUMP_EXTENT_LEVEL)
+		flags |= DUMP_NODE_EXTENTS;
+	flags |= DUMP_EXTENT_LEVEL;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	ino = string_to_inode(argv[optind]);
+	if (ino == 0)
+		return;
+
+	if (debugfs_read_inode(ino, &inode, argv[0]))
+		return;
+
+	if ((inode.i_flags & EXT4_EXTENTS_FL) == 0) {
+		fprintf(stderr, "%s: does not uses extent block maps\n",
+			argv[optind]);
+		return;
+	}
+
+	out = open_pager();
+	dump_extents(out, "", ino, flags);
+	close_pager(out);
+	return;
+}
+
 void do_chroot(int argc, char *argv[])
 {
 	ext2_ino_t inode;
