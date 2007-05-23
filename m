From: coly <colyli@gmail.com>
Subject: [RFC 3/5] inode reservation v0.1 (e2fsprogs patch)
Date: Thu, 24 May 2007 02:07:31 +0800
Message-ID: <1179943651.4179.54.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch only makes mke2fs support on-disk layout for inode
reservation. Just for experiment. e2fsck and other utils can not work
with magic inode yet.



diff -u -r
e2fsprogs-1.39-tyt1/debugfs/debugfs.c ../e2fsprogs/debugfs/debugfs.c
--- e2fsprogs-1.39-tyt1/debugfs/debugfs.c 2006-10-07 11:42:54.000000000
+0800
+++ ../e2fsprogs/debugfs/debugfs.c 2007-03-29 23:05:05.000000000 +0800
@@ -1215,7 +1215,8 @@
} else
mode = 010755;

- retval = ext2fs_new_inode(current_fs, dir, mode, 0, &free_inode);
+ retval = ext2fs_new_inode(current_fs, dir, mode, 0, &free_inode,
+ LINUX_S_ISDIR(mode) ? 1 : 0);
if (retval)
com_err("ext2fs_new_inode", retval, 0);
else
@@ -1294,7 +1295,7 @@
return;
}

- retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
+ retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile, 0);
if (retval) {
com_err(argv[0], retval, 0);
close(fd);
@@ -1384,7 +1385,7 @@
goto usage;
if (check_fs_read_write(argv[0]))
return;
- retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
+ retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile, 0);
if (retval) {
com_err(argv[0], retval, 0);
return;
diff -u -r
e2fsprogs-1.39-tyt1/debugfs/util.c ../e2fsprogs/debugfs/util.c
--- e2fsprogs-1.39-tyt1/debugfs/util.c 2006-10-07 11:40:28.000000000
+0800
+++ ../e2fsprogs/debugfs/util.c 2007-03-31 02:07:10.000000000 +0800
@@ -119,7 +119,7 @@

retval = ext2fs_namei(current_fs, root, cwd, str, &ino);
if (retval) {
- com_err(str, retval, "");
+ com_err(str, retval, " ");
return 0;
}
return ino;
diff -u -r
e2fsprogs-1.39-tyt1/e2fsck/pass1.c ../e2fsprogs/e2fsck/pass1.c
--- e2fsprogs-1.39-tyt1/e2fsck/pass1.c 2006-10-07 11:42:54.000000000
+0800
+++ ../e2fsprogs/e2fsck/pass1.c 2007-03-31 02:05:25.000000000 +0800
@@ -248,7 +248,7 @@
struct ext2_super_block *sb = ctx->fs->super;
struct ext2_inode_large *inode;
struct ext2_ext_attr_entry *entry;
- char *start, *end, *name;
+ char *start, *end;
int storage_size, remain, offs;
int problem = 0;

@@ -329,7 +329,7 @@

/* simple remove all possible EA(s) */
*((__u32 *)start) = 0UL;
- e2fsck_write_inode_full(ctx, pctx->ino, inode,
+ e2fsck_write_inode_full(ctx, pctx->ino, (struct ext2_inode *)inode,
EXT2_INODE_SIZE(sb), "pass1");
}

@@ -919,7 +919,6 @@

if (ctx->flags & E2F_FLAG_RESIZE_INODE) {
ext2fs_block_bitmap save_bmap;
- errcode_t retval;

save_bmap = fs->block_map;
fs->block_map = ctx->block_found_map;
diff -u -r
e2fsprogs-1.39-tyt1/e2fsck/pass3.c ../e2fsprogs/e2fsck/pass3.c
--- e2fsprogs-1.39-tyt1/e2fsck/pass3.c 2006-10-07 11:40:28.000000000
+0800
+++ ../e2fsprogs/e2fsck/pass3.c 2007-03-29 23:05:05.000000000 +0800
@@ -436,7 +436,7 @@
* Next find a free inode.
*/
retval = ext2fs_new_inode(fs, EXT2_ROOT_INO, 040700,
-   ctx->inode_used_map, &ino);
+   ctx->inode_used_map, &ino, 1);
if (retval) {
pctx.errcode = retval;
fix_problem(ctx, PR_3_ERR_LPF_NEW_INODE, &pctx);
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/alloc.c ../e2fsprogs/lib/ext2fs/alloc.c
--- e2fsprogs-1.39-tyt1/lib/ext2fs/alloc.c 2006-10-07 11:40:28.000000000
+0800
+++ ../e2fsprogs/lib/ext2fs/alloc.c 2007-04-30 15:21:01.000000000 +0800
@@ -26,6 +26,192 @@
#include "ext2_fs.h"
#include "ext2fs.h"

+
+static errcode_t ext2fs_reserve_inodes_area(ext2_filsys fs, 
+     struct ext2_magic_inode * prev_link_minode)
+{
+ struct ext2_magic_inode lastres_minode;
+ struct ext2_magic_inode new_link_minode;
+ ext2_ino_t reserv_size;
+ ext2_ino_t new_link_ino;
+ ext2_ino_t lastres_ino;
+ ext2_ino_t dir_group;
+ ext2_ino_t itable_idx;
+ int find = 0;
+ errcode_t retval; 
+ 
+ reserv_size = prev_link_minode->mi_next_ressize;
+ if(reserv_size > EXT2_INODES_PER_GROUP(fs->super))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+
+ for(dir_group = 0; dir_group < fs->group_desc_count; dir_group ++)
+ {
+ lastres_ino = ext2fs_get_group_lastres_ino(fs, dir_group);
+ retval = ext2fs_read_magic_inode(fs, lastres_ino,
+ &lastres_minode);
+ if(retval)
+ return retval;
+ retval = ext2fs_check_magic_inode(&lastres_minode,
+ EXT2_MINODE_TYPE_LASTRES);
+ if(retval)
+ return retval;
+ itable_idx = lastres_minode.mi_lastres_ino %
+ EXT2_INODES_PER_GROUP(fs->super);
+ if((EXT2_INODES_PER_GROUP(fs->super) - itable_idx) >=
+ reserv_size) {
+ find = 1;
+ break;
+ }
+ }
+ if (!find)
+ return EXT2_ET_DIR_NO_SPACE;
+ new_link_ino = lastres_minode.mi_lastres_ino + reserv_size;
+ if(ext2fs_test_inode_bitmap(fs->inode_map, new_link_ino))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ ext2fs_inode_alloc_stats2(fs, new_link_ino, +1, 0);
+ ext2fs_setup_magic_inode(&new_link_minode, 
+ EXT2_MINODE_TYPE_LINK);
+ new_link_minode.mi_next_ino = 0;
+ new_link_minode.mi_parent_ino = prev_link_minode->mi_parent_ino;
+ new_link_minode.mi_current_ressize = reserv_size;
+ reserv_size *= 2;
+ if(reserv_size > EXT2_INODES_PER_GROUP(fs->super))
+ reserv_size = EXT2_INODES_PER_GROUP(fs->super);
+ new_link_minode.mi_next_ressize = reserv_size;
+ retval = ext2fs_write_magic_inode(fs, new_link_ino, &new_link_minode);
+ if(retval)
+ return retval;
+ lastres_minode.mi_lastres_ino = new_link_ino;
+ retval = ext2fs_write_magic_inode(fs, lastres_ino, 
+ &lastres_minode);
+ if(retval)
+ return retval;
+ prev_link_minode->mi_next_ino = new_link_ino;
+ return 0;
+}
+
+errcode_t ext2fs_newdir_inode (ext2_filsys fs, ext2_ino_t dir_group, 
+       int * find, ext2_ino_t * find_ino)
+{
+ struct ext2_magic_inode lastres_minode, link_minode;
+ ext2_ino_t lastres_ino;
+ ext2_ino_t itable_idx;
+ ext2_ino_t start_ino, end_ino;
+ errcode_t retval;
+ 
+
+
+ lastres_ino = ext2fs_get_group_lastres_ino(fs, dir_group);
+ retval = ext2fs_read_magic_inode(fs, lastres_ino,
+ &lastres_minode);  
+ if(retval)
+ return retval;
+ retval = ext2fs_check_magic_inode(&lastres_minode, 
+ EXT2_MINODE_TYPE_LASTRES);
+ if(retval)
+ return retval;
+ itable_idx = lastres_minode.mi_lastres_ino % 
+ EXT2_INODES_PER_GROUP(fs->super);
+ if((EXT2_INODES_PER_GROUP(fs->super) - itable_idx) < 
+ EXT2_INIT_RESERVE_INODES) {
+ * find = 0;
+ return 0;
+ }
+ start_ino = lastres_minode.mi_lastres_ino + 1;
+
+ if(start_ino < EXT2_FIRST_INODE(fs->super))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ if(start_ino > (dir_group + 1) * EXT2_INODES_PER_GROUP(fs->super)) {
+ * find = 0;
+ return 0;
+ }
+ end_ino = start_ino + EXT2_INIT_RESERVE_INODES - 1; 
+ if(end_ino > (dir_group + 1 )* EXT2_INODES_PER_GROUP(fs->super)) {
+ * find = 0;
+ return 0;
+ }
+ if(ext2fs_fast_test_inode_bitmap(fs->inode_map, start_ino))
+ return EXT2_ET_INODE_ALLOC_FAIL;
+ if(ext2fs_fast_test_inode_bitmap(fs->inode_map, end_ino))
+ return EXT2_ET_INODE_ALLOC_FAIL;
+ lastres_minode.mi_lastres_ino = end_ino;
+ retval = ext2fs_write_magic_inode(fs, lastres_ino, &lastres_minode);
+ if(retval)
+ return retval;
+ ext2fs_setup_magic_inode(&link_minode, EXT2_MINODE_TYPE_LINK);
+ link_minode.mi_next_ino = 0;
+ link_minode.mi_parent_ino = start_ino;
+ link_minode.mi_current_ressize = EXT2_INIT_RESERVE_INODES;
+ link_minode.mi_next_ressize = EXT2_INIT_RESERVE_INODES * 2;
+ if (link_minode.mi_next_ressize >
+ EXT2_INODES_PER_GROUP(fs->super))
+ link_minode.mi_next_ressize = 
+ EXT2_INODES_PER_GROUP(fs->super);
+ retval = ext2fs_write_magic_inode(fs, end_ino, &link_minode);
+ if (retval)
+ return retval;
+ ext2fs_inode_alloc_stats2(fs, end_ino, +1, 0);
+
+ * find = 1;
+ * find_ino = start_ino;
+ return 0;
+}
+
+errcode_t ext2fs_newfile_inode(ext2_filsys fs, ext2_ino_t dir_group,
+        ext2_ino_t dir, int * find, 
+        ext2_ino_t * find_ino)
+{
+ struct ext2_magic_inode magic_inode;
+ ext2_ino_t start_ino, end_ino;
+ ext2_ino_t link_ino;
+ int group_nr;
+ int reserv_inodes_nr = EXT2_INIT_RESERVE_INODES;
+ int i;
+ errcode_t retval;
+
+ end_ino = ((dir / EXT2_INIT_RESERVE_INODES) * 
+ EXT2_INIT_RESERVE_INODES) + 
+ reserv_inodes_nr;
+ if(end_ino > (dir_group + 1) * EXT2_INODES_PER_GROUP(fs->super))
+ return EXT2_ET_INODE_ALLOC_FAIL;
+ if(end_ino < EXT2_FIRST_INODE(fs->super))
+ return EXT2_ET_INODE_ALLOC_FAIL;
+ start_ino = dir + 1;
+ if(start_ino < EXT2_FIRST_INODE(fs->super))
+ start_ino = EXT2_FIRST_INODE(fs->super);
+ group_nr = fs->group_desc_count;
+ while(group_nr --) {
+ for(i = 0; i < (link_ino - start_ino); i ++) {
+ if(!ext2fs_fast_test_inode_bitmap(fs->inode_map, 
+ start_ino + i)) {
+ * find = 1;
+ * find_ino = start_ino + i;
+ return 0;
+ }
+ }
+ retval = ext2fs_read_magic_inode(fs, end_ino, &magic_inode);
+ if(retval)
+ return retval;
+ retval = (ext2fs_check_magic_inode(&magic_inode, 
+ EXT2_MINODE_TYPE_LINK));
+ if(retval)
+ return retval;
+ if(magic_inode.mi_next_ino == 0) {
+ retval = ext2fs_reserve_inodes_area(fs, &magic_inode); 
+ if(retval)
+ return retval;
+ }
+ if((magic_inode.mi_next_ressize) >
+ EXT2_INODES_PER_GROUP(fs->super))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ retval = ext2fs_write_magic_inode(fs, end_ino, &magic_inode);
+ start_ino = magic_inode.mi_next_ino;
+ end_ino = start_ino + magic_inode.mi_next_ressize - 1;
+ }
+ * find = 0;
+ return 0;
+}
+
/*
  * Right now, just search forward from the parent directory's block
  * group to find the next free inode.
@@ -34,11 +220,14 @@
  */
errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, 
   int mode EXT2FS_ATTR((unused)),
-    ext2fs_inode_bitmap map, ext2_ino_t *ret)
+    ext2fs_inode_bitmap map, ext2_ino_t *ret,
+    int is_dir)
{
ext2_ino_t dir_group = 0;
- ext2_ino_t i;
- ext2_ino_t start_inode;
+ ext2_ino_t start_ino;
+ int group_nr;
+ int find = 0;
+ errcode_t retval;

EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

@@ -46,26 +235,36 @@
map = fs->inode_map;
if (!map)
return EXT2_ET_NO_INODE_BITMAP;
- 
+ 
+ group_nr = fs->group_desc_count;
if (dir > 0) 
dir_group = (dir - 1) / EXT2_INODES_PER_GROUP(fs->super);

- start_inode = (dir_group * EXT2_INODES_PER_GROUP(fs->super)) + 1;
- if (start_inode < EXT2_FIRST_INODE(fs->super))
- start_inode = EXT2_FIRST_INODE(fs->super);
- i = start_inode;
+ if (is_dir) {
+ while(group_nr --) {
+ retval = ext2fs_newdir_inode(fs, dir_group, 
+      &find, &start_ino);
+ if(retval)
+ return retval;
+ if(find)
+ break;
+ dir_group ++;
+ if(dir_group == (fs->group_desc_count - 1))
+ dir_group = 0;
+ }
+ } else {
+ retval = ext2fs_newfile_inode(fs, dir_group, dir, 
+ &find, &start_ino);
+ if(retval)
+ return retval;
+ }
+ if(!find)
+ return EXT2_ET_DIR_NO_SPACE;

- do {
- if (!ext2fs_fast_test_inode_bitmap(map, i))
- break;
- i++;
- if (i > fs->super->s_inodes_count)
- i = EXT2_FIRST_INODE(fs->super);
- } while (i != start_inode);
- 
- if (ext2fs_test_inode_bitmap(map, i))
+ if (ext2fs_test_inode_bitmap(map, start_ino))
return EXT2_ET_INODE_ALLOC_FAIL;
- *ret = i;
+
+ *ret = start_ino;
return 0;
}

diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/ext2_err.et.in ../e2fsprogs/lib/ext2fs/ext2_err.et.in
--- e2fsprogs-1.39-tyt1/lib/ext2fs/ext2_err.et.in 2006-10-07
11:42:54.000000000 +0800
+++ ../e2fsprogs/lib/ext2fs/ext2_err.et.in 2007-04-02 17:23:32.000000000
+0800
@@ -293,6 +293,15 @@
ec EXT2_ET_RESIZE_INODE_CORRUPT,
"Resize inode is corrupt"

+ec EXT2_ET_MAGIC_INODE_CORRUPT,
+ "Magic inode is corrupt"
+
+ec EXT2_ET_FIRST_INODE_BEYOND_RESERVED_INODES,
+ "First inode in filesystem is beyond initial reserved inodes area"
+
+ec EXT2_ET_MAGIC_INODE_TOO_LARGE,
+ "Magic inode is larger than ext2 inode"
+
ec EXT2_ET_SET_BMAP_NO_IND,
"Missing indirect block not present"

diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/ext2_fs.h ../e2fsprogs/lib/ext2fs/ext2_fs.h
--- e2fsprogs-1.39-tyt1/lib/ext2fs/ext2_fs.h 2006-10-07
11:42:54.000000000 +0800
+++ ../e2fsprogs/lib/ext2fs/ext2_fs.h 2007-04-30 15:31:28.000000000
+0800
@@ -385,6 +385,31 @@
__u16 i_pad1;
};

+#define EXT2_MINODE_MAGIC_STR "ext_magic_inode\0"
+#define EXT2_MINODE_MAGIC_LEN 16
+
+#define EXT2_MINODE_TYPE_LASTRES 0x0001
+#define EXT2_MINODE_TYPE_LINK 0x0002
+
+struct ext2_magic_inode {
+ __u32  mi_zeropad; /* Zero pad */
+ __u8    mi_magic[EXT2_MINODE_MAGIC_LEN];/* Magic string */
+ __u32  mi_checksum; /* Checksum for magic string */
+ __u32  mi_type; /* Type of magic inode */
+ __u32  mi_lastres_ino; /* Last reserved inode number in current block
*/
+ /* group, for EXT2_MINODE_TYPE_LASTRES magic */
+ /* inode */
+ __u32  mi_next_ino; /* Inode number for head inode of next */
+ /* reserved inodes area */
+ __u32  mi_parent_ino; /* Dir inode number */
+ __u32  mi_parent_ctime; /* Dir inode ctime */
+ __u32  mi_current_ressize; /* Reserved inodes size for current
reserved */
+ /* inodes area */
+ __u32  mi_next_ressize; /* Reserved inodes size for next reserved */
+ /* inodes area */
+};
+
+
#define i_size_high i_dir_acl

#if defined(__KERNEL__) || defined(__linux__)
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/ext2fs.h ../e2fsprogs/lib/ext2fs/ext2fs.h
--- e2fsprogs-1.39-tyt1/lib/ext2fs/ext2fs.h 2006-10-07
11:42:54.000000000 +0800
+++ ../e2fsprogs/lib/ext2fs/ext2fs.h 2007-04-30 15:53:34.000000000 +0800
@@ -121,7 +121,7 @@
typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;

#define EXT2_FIRST_INODE(s) EXT2_FIRST_INO(s)
-
+#define EXT2_INIT_RESERVE_INODES 16

/*
  * Badblocks list definitions
@@ -224,6 +224,10 @@
struct ext2_inode *inode);
errcode_t (*write_inode)(ext2_filsys fs, ext2_ino_t ino,
struct ext2_inode *inode);
+ errcode_t (*read_magic_inode)(ext2_filsys fs, ext2_ino_t ino,
+ struct ext2_magic_inode *magic_inode);
+ errcode_t (*write_magic_inode)(ext2_filsys fs, ext2_ino_t ino,
+ struct ext2_magic_inode *magic_inode);
ext2_badblocks_list badblocks;
ext2_dblist dblist;
__u32 stride; /* for mke2fs */
@@ -487,8 +491,10 @@
  */

/* alloc.c */
-extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int
mode,
-   ext2fs_inode_bitmap map, ext2_ino_t *ret);
+errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
+    int mode EXT2FS_ATTR((unused)),
+    ext2fs_inode_bitmap map, ext2_ino_t *ret,
+    int is_dir);
extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
  ext2fs_block_bitmap map, blk_t *ret);
extern errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start,
@@ -863,7 +869,15 @@
    struct ext2_inode * inode);
extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t
*blocks);
extern errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino);
-
+extern errcode_t ext2fs_check_magic_inode(struct ext2_magic_inode *
minode, int type);
+extern void ext2fs_setup_magic_inode(struct ext2_magic_inode * minode,
int type);
+extern ext2_ino_t ext2fs_get_group_lastres_ino(ext2_filsys fs,
ext2_ino_t group);
+extern errcode_t ext2fs_read_magic_inode(ext2_filsys fs, ext2_ino_t
ino,
+ struct ext2_magic_inode * magic_inode);
+extern errcode_t ext2fs_write_magic_inode(ext2_filsys fs, ext2_ino_t
ino,
+ struct ext2_magic_inode * magic_inode);
+extern errcode_t ext2fs_update_magic_inode_ctime(ext2_filsys fs,
ext2_ino_t parent_ino,
+ __u32 parent_ctime);
/* inode_io.c */
extern io_manager inode_io_manager;
extern errcode_t ext2fs_inode_io_intern(ext2_filsys fs, ext2_ino_t ino, 
@@ -975,6 +989,8 @@
   int bufsize);
extern void ext2fs_swap_inode(ext2_filsys fs,struct ext2_inode *t,
      struct ext2_inode *f, int hostorder);
+extern void ext2fs_swap_magic_inode(ext2_filsys fs, struct
ext2_magic_inode *t,
+     struct ext2_magic_inode *f);

/* valid_blk.c */
extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/extent.c ../e2fsprogs/lib/ext2fs/extent.c
--- e2fsprogs-1.39-tyt1/lib/ext2fs/extent.c 2006-10-07
11:42:54.000000000 +0800
+++ ../e2fsprogs/lib/ext2fs/extent.c 2007-03-31 01:56:42.000000000 +0800
@@ -390,5 +390,5 @@
}

eh = (struct ext3_extent_header *) inode.i_blocks;
-
+ return 0;
}
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/inode.c ../e2fsprogs/lib/ext2fs/inode.c
--- e2fsprogs-1.39-tyt1/lib/ext2fs/inode.c 2006-10-07 11:40:28.000000000
+0800
+++ ../e2fsprogs/lib/ext2fs/inode.c 2007-04-30 16:28:50.000000000 +0800
@@ -588,7 +588,6 @@
       (struct ext2_inode_large *) inode, 
       0, length);
#endif
-
/* Update the inode cache */
fs->icache->cache_last = (fs->icache->cache_last + 1) %
fs->icache->cache_size;
@@ -605,6 +604,78 @@
sizeof(struct ext2_inode));
}

+errcode_t ext2fs_read_magic_inode(ext2_filsys fs, ext2_ino_t ino,
+ struct ext2_magic_inode * magic_inode)
+{
+ unsigned long group, block, block_nr, offset;
+ char *ptr;
+ errcode_t retval;
+ int clen, length;
+ io_channel io;
+ void * buffer = NULL;
+
+ EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+ /* Check to see if user has an override function */
+ if (fs->read_magic_inode) {
+ retval = (fs->read_magic_inode)(fs, ino, magic_inode);
+ if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
+ return retval;
+ }
+
+ if ((ino == 0) || (ino > fs->super->s_inodes_count))
+ return EXT2_ET_BAD_INODE_NUM;
+ if (fs->flags & EXT2_FLAG_IMAGE_FILE) 
+ return EXT2_ET_UNIMPLEMENTED;
+
+ group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
+ offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
+ EXT2_INODE_SIZE(fs->super);
+ block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
+ if (!fs->group_desc[(unsigned)group].bg_inode_table)
+ return EXT2_ET_MISSING_INODE_TABLE;
+ block_nr = fs->group_desc[(unsigned)group].bg_inode_table + 
+ block;
+ io = fs->io;
+ offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
+
+ length = sizeof(struct ext2_magic_inode);
+ if(length > EXT2_INODE_SIZE(fs->super))
+ return EXT2_ET_MAGIC_INODE_TOO_LARGE;
+
+ retval = ext2fs_get_mem(fs->blocksize, &buffer);
+ if (retval)
+ return retval;
+
+ ptr = (char *) magic_inode;
+ while (length) {
+ clen = length;
+ if ((offset + length) > fs->blocksize)
+ clen = fs->blocksize - offset;
+
+ retval = io_channel_read_blk(io, block_nr, 1,
+      buffer);
+ if (retval)
+ return retval;
+
+ memcpy(ptr, ((char *) buffer) + (unsigned) offset,
+        clen);
+
+ offset = 0;
+ length -= clen;
+ ptr += clen;
+ block_nr++;
+ }
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+ if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
+     (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
+ ext2fs_swap_magic_inode(fs, 
+ (struct ext2_magic_inode *) magic_inode, 0);
+#endif
+ return 0;
+}
+
errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
  struct ext2_inode * inode, int bufsize)
{
@@ -618,6 +689,7 @@

/* Check to see if user provided an override function */
if (fs->write_inode) {
+ printf("call fs->write_inode\n");
retval = (fs->write_inode)(fs, ino, inode);
if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
return retval;
@@ -723,6 +795,84 @@
       sizeof(struct ext2_inode));
}

+errcode_t ext2fs_write_magic_inode(ext2_filsys fs, ext2_ino_t ino,
+   struct ext2_magic_inode * magic_inode)
+{
+ unsigned long group, block, block_nr, offset;
+ errcode_t retval = 0;
+ char *ptr;
+ void * buffer = NULL;
+ int clen, length;
+
+ EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+ /* Check to see if user provided an override function */
+ if (fs->write_magic_inode) {
+ printf("call fs->write_magic_inode\n");
+ retval = (fs->write_magic_inode)(fs, ino, magic_inode);
+ if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
+ return retval;
+ }
+
+ if (!(fs->flags & EXT2_FLAG_RW))
+ return EXT2_ET_RO_FILSYS;
+
+ if ((ino == 0) || (ino > fs->super->s_inodes_count))
+ return EXT2_ET_BAD_INODE_NUM;
+
+ length = sizeof(struct ext2_magic_inode);
+ if (length > EXT2_INODE_SIZE(fs->super))
+ return EXT2_ET_MAGIC_INODE_TOO_LARGE;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+ if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
+     (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
+ ext2fs_swap_magic_inode(fs, magic_inode,
+ magic_inode);
+#endif
+ 
+ group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
+ offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
+ EXT2_INODE_SIZE(fs->super);
+ block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
+ if (!fs->group_desc[(unsigned) group].bg_inode_table)
+ return EXT2_ET_MISSING_INODE_TABLE;
+ block_nr = fs->group_desc[(unsigned) group].bg_inode_table + block;
+
+ offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
+
+ ptr = (char *) magic_inode;
+ retval = ext2fs_get_mem(fs->blocksize, &buffer);
+ if(retval)
+ return retval;
+ while (length) {
+ clen = length;
+ if ((offset + length) > fs->blocksize)
+ clen = fs->blocksize - offset;
+ retval = io_channel_read_blk(fs->io, block_nr, 1,
+      buffer);
+ if (retval)
+ goto errout;
+
+ memcpy((char *) buffer + (unsigned) offset, 
+        ptr, clen);
+
+ retval = io_channel_write_blk(fs->io, block_nr, 
+ 1, buffer);
+ if (retval)
+ goto errout;
+
+ offset = 0;
+ ptr += clen;
+ length -= clen;
+ block_nr++;
+ }
+ fs->flags |= EXT2_FLAG_CHANGED;
+errout:
+ ext2fs_free_mem(&buffer); 
+ return retval;
+}
+
/* 
  * This function should be called when writing a new inode.  It makes
  * sure that extra part of large inodes is initialized properly.
@@ -735,8 +885,10 @@
struct ext2_inode_large *large_inode;

if (size == sizeof(struct ext2_inode))
+ {
return ext2fs_write_inode_full(fs, ino, inode,
       sizeof(struct ext2_inode));
+ }

buf = malloc(size);
if (!buf)
@@ -799,3 +951,79 @@
return 0;
}

+/*
+ * LASTRES type magic inode locates at the penultimate inode
+ * in the lastest inode block of inode table.
+ */
+ext2_ino_t ext2fs_get_group_lastres_ino(ext2_filsys fs, ext2_ino_t
group)
+{
+ ext2_ino_t lastres_ino;
+ lastres_ino = (group + 1) * EXT2_INODES_PER_GROUP(fs->super) - 1;
+ return lastres_ino;
+}
+
+errcode_t ext2fs_check_magic_inode(struct ext2_magic_inode * minode, 
+ int type)
+{
+ int i, sum;
+ if(minode->mi_zeropad != 0)
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ if(strncmp((char *)minode->mi_magic, EXT2_MINODE_MAGIC_STR, 
+ EXT2_MINODE_MAGIC_LEN)) 
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ sum = 0;
+ for(i = 0; i < EXT2_MINODE_MAGIC_LEN; i ++)
+ sum += minode->mi_magic[i];
+ if((sum + minode->mi_checksum) != 0)
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ if(minode->mi_type != type)
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ return 0;
+}
+
+void ext2fs_setup_magic_inode(struct ext2_magic_inode * minode,
+ int type)
+{
+ int i, sum;
+
+ memset(minode, 0, sizeof(struct ext2_magic_inode));
+ strncpy((char *)minode->mi_magic, EXT2_MINODE_MAGIC_STR,
+ EXT2_MINODE_MAGIC_LEN);
+ sum = 0;
+ for(i = 0; i < EXT2_MINODE_MAGIC_LEN; i++)
+ sum += minode->mi_magic[i];
+ minode->mi_checksum = 0 - sum;
+ minode->mi_type = type;
+}
+
+errcode_t ext2fs_update_magic_inode_ctime(ext2_filsys fs,
+     ext2_ino_t parent_ino, 
+     __u32 parent_ctime)
+{
+ ext2_ino_t link_mino;
+ struct ext2_magic_inode link_minode;
+ int retval;
+ 
+ if (parent_ino == EXT2_ROOT_INO)
+ link_mino = EXT2_INIT_RESERVE_INODES;
+ else
+ link_mino = parent_ino + 
+ EXT2_INIT_RESERVE_INODES - 1;
+
+ retval = ext2fs_read_magic_inode(fs, link_mino, &link_minode);
+ if (retval)
+ return retval;
+ retval = ext2fs_check_magic_inode(&link_minode, 
+ EXT2_MINODE_TYPE_LINK);
+ if (retval)
+ return retval;
+
+ link_minode.mi_parent_ctime = parent_ctime;
+
+ retval = ext2fs_write_magic_inode(fs, link_mino, &link_minode);
+ if (retval)
+ return retval;
+ return 0;
+}
+
+
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/mkdir.c ../e2fsprogs/lib/ext2fs/mkdir.c
--- e2fsprogs-1.39-tyt1/lib/ext2fs/mkdir.c 2006-10-07 11:40:28.000000000
+0800
+++ ../e2fsprogs/lib/ext2fs/mkdir.c 2007-04-30 15:48:18.000000000 +0800
@@ -47,7 +47,7 @@
*/
if (!ino) {
retval = ext2fs_new_inode(fs, parent, LINUX_S_IFDIR | 0755,
-   0, &ino);
+   0, &ino, 1);
if (retval)
goto cleanup;
}
@@ -89,6 +89,12 @@
inode.i_size = fs->blocksize;

/*
+ * copy i_ctime to mi_parent_ctime of its link magic inode
+ */
+ retval = ext2fs_update_magic_inode_ctime(fs, ino, inode.i_ctime);
+ if (retval)
+ goto cleanup;
+ /*
* Write out the inode and inode data block
*/
retval = ext2fs_write_dir_block(fs, blk, block);
diff -u -r
e2fsprogs-1.39-tyt1/lib/ext2fs/swapfs.c ../e2fsprogs/lib/ext2fs/swapfs.c
--- e2fsprogs-1.39-tyt1/lib/ext2fs/swapfs.c 2006-10-07
11:42:54.000000000 +0800
+++ ../e2fsprogs/lib/ext2fs/swapfs.c 2007-03-29 23:05:05.000000000 +0800
@@ -260,4 +260,17 @@
sizeof(struct ext2_inode));
}

+void ext2fs_swap_magic_inode(ext2_filsys fs, struct ext2_magic_inode
*t,
+      struct ext2_magic_inode *f)
+{
+ t->mi_zeropad = ext2fs_swab32(f->mi_zeropad);
+ t->mi_checksum = ext2fs_swab32(f->mi_checksum);
+ t->mi_type = ext2fs_swab32(f->mi_type);
+ t->mi_lastres_ino = ext2fs_swab32(f->mi_lastres_ino);
+ t->mi_next_ino = ext2fs_swab32(f->mi_next_ino);
+ t->mi_parent_ino = ext2fs_swab32(f->mi_parent_ino);
+ t->mi_current_ressize = ext2fs_swab32(f->mi_current_ressize);
+ t->mi_next_ressize = ext2fs_swab32(f->mi_next_ressize);
+}
+
#endif
diff -u -r e2fsprogs-1.39-tyt1/misc/mke2fs.c ../e2fsprogs/misc/mke2fs.c
--- e2fsprogs-1.39-tyt1/misc/mke2fs.c 2006-10-07 11:42:54.000000000
+0800
+++ ../e2fsprogs/misc/mke2fs.c 2007-04-19 15:50:12.000000000 +0800
@@ -473,6 +473,57 @@
}
}

+static errcode_t setup_magic_inodes(ext2_filsys fs)
+{
+ struct ext2_group_desc *bg = fs->group_desc;
+ struct ext2_magic_inode magic_inode;
+ ext2_ino_t lastres_ino;
+ ext2_ino_t start_ino;
+ int i;
+ errcode_t retval;
+
+ /* for root directory */
+ start_ino = EXT2_INIT_RESERVE_INODES;
+ ext2fs_setup_magic_inode(&magic_inode, 
+ EXT2_MINODE_TYPE_LINK);
+ magic_inode.mi_next_ino = 0;
+ magic_inode.mi_parent_ino = EXT2_ROOT_INO;
+ magic_inode.mi_current_ressize = EXT2_INIT_RESERVE_INODES;
+ magic_inode.mi_next_ressize = EXT2_INIT_RESERVE_INODES * 2;
+ if(magic_inode.mi_next_ressize > 
+    EXT2_INODES_PER_GROUP(fs->super))
+ magic_inode.mi_next_ressize = 
+ EXT2_INODES_PER_GROUP(fs->super);
+ retval = ext2fs_write_magic_inode(fs, EXT2_INIT_RESERVE_INODES, 
+ &magic_inode);
+ if(retval)
+ return retval;
+ ext2fs_inode_alloc_stats2(fs, EXT2_INIT_RESERVE_INODES, +1, 0);
+ 
+ /* for each block group */
+ for (i = 0; i < fs->group_desc_count; i++, bg++) {
+ start_ino = i * EXT2_INODES_PER_GROUP(fs->super);
+ if(start_ino < EXT2_FIRST_INODE(fs->super)) {
+ if(EXT2_FIRST_INODE(fs->super) >= 
+    EXT2_INIT_RESERVE_INODES) 
+ return EXT2_ET_FIRST_INODE_BEYOND_RESERVED_INODES;
+ start_ino = EXT2_INIT_RESERVE_INODES;
+ } 
+
+ lastres_ino = ext2fs_get_group_lastres_ino(fs, i);
+ if(i && ext2fs_test_inode_bitmap(fs->inode_map, start_ino))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ if(ext2fs_test_inode_bitmap(fs->inode_map, lastres_ino))
+ return EXT2_ET_MAGIC_INODE_CORRUPT;
+ ext2fs_setup_magic_inode(&magic_inode, 
+ EXT2_MINODE_TYPE_LASTRES);
+ magic_inode.mi_lastres_ino = start_ino;
+ retval = ext2fs_write_magic_inode(fs, lastres_ino,
+ &magic_inode);
+ ext2fs_inode_alloc_stats2(fs, lastres_ino, +1, 0);
+ }
+ return 0;
+}

static void create_root_dir(ext2_filsys fs)
{
@@ -1622,6 +1673,13 @@
}
setup_lazy_bg(fs);
write_inode_tables(fs);
+ retval = setup_magic_inodes(fs);
+ if (retval) {
+ com_err("setup_magic_inodes", retval,
+ _("while setupping magic inodes for directories"
+   " inodes reservation"));
+ exit(1);
+ }
create_root_dir(fs);
create_lost_and_found(fs);
reserve_inodes(fs);
diff -u -r
e2fsprogs-1.39-tyt1/resize/online.c ../e2fsprogs/resize/online.c
--- e2fsprogs-1.39-tyt1/resize/online.c 2006-10-07 11:42:52.000000000
+0800
+++ ../e2fsprogs/resize/online.c 2007-04-07 20:26:27.000000000 +0800
@@ -47,7 +47,7 @@
fs->super->s_first_data_block,
EXT2_BLOCKS_PER_GROUP(fs->super)),
EXT2_DESC_PER_BLOCK(fs->super));
- printf("old desc_blocks = %d, new_desc_blocks = %d\n",
fs->desc_blocks,
+ printf("old desc_blocks = %lu, new_desc_blocks = %d\n",
fs->desc_blocks,
       new_desc_blocks);
if (!(fs->super->s_feature_compat & 
      EXT2_FEATURE_COMPAT_RESIZE_INODE) &&


