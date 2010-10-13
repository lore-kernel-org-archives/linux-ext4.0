From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Wed, 13 Oct 2010 18:14:08 +0200
Message-ID: <AANLkTi=GNqOgN0baLVckQcY4FYoMwvjCgVedmWACES1R@mail.gmail.com>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
	<20101009180357.GG18454@thunk.org>
	<20101011142813.GC3830@quack.suse.cz>
	<20101011145945.166695e3.akpm@linux-foundation.org>
	<20101012231408.GC3812@quack.suse.cz>
	<AANLkTimqbW7+wsXVoLa1Tx0K3VaDfrYKUE8owyD1VUxO@mail.gmail.com>
	<AANLkTinD=EE0yYFzBHdvu-fKCQhfMH+DetekHWd-RZc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56994 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0JMQOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Oct 2010 12:14:10 -0400
Received: by qyk2 with SMTP id 2so970245qyk.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Oct 2010 09:14:09 -0700 (PDT)
In-Reply-To: <AANLkTinD=EE0yYFzBHdvu-fKCQhfMH+DetekHWd-RZc7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 13, 2010 at 10:49 AM, Amir G.
<amir73il@users.sourceforge.net> wrote:
> On Wed, Oct 13, 2010 at 1:14 AM, Jan Kara <jack@suse.cz> wrote:
>>
>> On Mon 11-10-10 14:59:45, Andrew Morton wrote:
>> > On Mon, 11 Oct 2010 16:28:13 +0200=A0Jan Kara <jack@suse.cz> wrote=
:
>> >
>> > > =A0 Doing allocation at mmap time does not really work - on each=
 mmap we
>> > > would have to map blocks for the whole file which would make mma=
p really
>> > > expensive operation. Doing it at page-fault as you suggest in (2=
a) works
>> > > (that's the second plausible option IMO) but the increased fragm=
entation
>> > > and thus loss of performance is rather noticeable. I don't have =
current
>> > > numbers but when I tried that last year Berkeley DB was like two=
 or three
>> > > times slower.
>> >
>> > ouch.
>> >
>> > Can we fix the layout problem? =A0Are reservation windows of no us=
e here?
>> =A0Reservation windows do not work for this load. The reason is that=
 the
>> page-fault order is completely random so we just spend time creating=
 and
>> removing tiny reservation windows because the next page fault doing
>> allocation is scarcely close enough to fall into the small window.
>> =A0The logic in ext3_find_goal() ends up picking blocks close togeth=
er for
>> blocks belonging to the same indirect block if we are lucky but they
>> definitely won't be sequentially ordered. For Berkeley DB the situat=
ion is
>> made worse by the fact that there are several database files and the=
ir
>> blocks end up interleaved.
>> =A0So we could improve the layout but we'd have to tweak the reserva=
tion
>> logic and allocator and it's not completely clear to me how.
>> =A0One thing to note is that currently, ext3 *is* in fact doing dela=
yed
>> allocation for writes via mmap. We just never called it like that an=
d never
>> bothered to do proper space estimation...
>>
>> > > > 3) Keep a global counter of sparse blocks which are mapped at =
mmap()
>> > > > time, and update it as blocks are allocated, or when the regio=
n is
>> > > > freed at munmap() time.
>> > > =A0 Here again I see the problem that mapping all file blocks at=
 mmap time
>> > > is rather expensive and so does not seem viable to me. Also the
>> > > overestimation of needed blocks could be rather huge.
>> >
>> > When I did ext2 delayed allocation back in, err, 2001 I had
>> > considerable trouble working out how many blocks to actually reser=
ve
>> > for a file block, because it also had to reserve the indirect bloc=
ks.
>> > One file block allocation can result in reserving four disk blocks=
!
>> > And iirc it was not possible with existing in-core data structures=
 to
>> > work out whether all four blocks needed reserving until the actual
>> > block allocation had occurred. =A0So I ended up reserving the wors=
t-case
>> > number of indirects, based upon the file offset. =A0If the disk ra=
n out
>> > of "space" I'd do a forced writeback to empty all the reservations=
 and
>> > would then take a look to see if the disk was _really_ out of spac=
e.
>> >
>> > Is all of this an issue with this work? =A0If so, what approach di=
d you
>> > take?
>> =A0Yeah, I've spotted exactly the same problem. How I decided to sol=
ve it in
>> the end is that in memory we keep track of each indirect block that =
has
>> delay-allocated buffer under it. This allows us to reserve space for=
 each
>> indirect block at most once (I didn't bother with making the account=
ing
>> precise for double or triple indirect blocks so when I need to reser=
ve
>> space for indirect block, I reserve the whole path just to be sure).=
 This
>> pushes the error in estimation to rather acceptable range for reason=
ably
>> common workloads - the error can still be 50% for workloads which us=
e just
>> one data block in each indirect block but even in this case the abso=
lute
>> number of blocks falsely reserved is small.
>> =A0The cost is of course increased complexity of the code, the memor=
y
>> spent for tracking those indirect blocks (32 bytes per indirect bloc=
k), and
>> some time for lookups in the RB-tree of the structures. At least the=
 nice
>> thing is that when there are no delay-allocated blocks, there isn't =
any
>> overhead (tree is empty).
>>
>
> How about allocating *only* the indirect blocks on page fault.
> IMHO it seems like a fair mixture of high quota accuracy, low
> complexity of the accounting code and low file fragmentation (only
> indirect may be a bit further away from data).
>
> In my snapshot patches I use the @create arg to get_blocks_handle() t=
o
> pass commands just like "allocate only indirect blocks".
> The patch is rather simple. I can prepare it for ext3 if you like.
>
> Amir.
>

Here is the indirect allocation patch.
The following debugfs dump shows the difference between a 1G file
allocated by dd (indirect interleaved with data) and by mmap (indirect
sequential before data).
(I did not test performance and I ignored SIGBUS at the end of mmap
file allocation)

debugfs:  stat dd.1G
Inode: 15   Type: regular    Mode:  0644   Flags: 0x0
Generation: 4035748347    Version: 0x00000000
User:     0   Group:     0   Size: 1073741824
=46ile ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 2099208
=46ragment:  Address: 0    Number: 0    Size: 0
ctime: 0x4cb5d1a9 -- Wed Oct 13 17:35:05 2010
atime: 0x4cb5d199 -- Wed Oct 13 17:34:49 2010
mtime: 0x4cb5d1a9 -- Wed Oct 13 17:35:05 2010
Size of extra inode fields: 4
BLOCKS:
(0-11):16384-16395, (IND):16396, (12-134):16397-16519,
(135-641):17037-17543, (642-1035):17792-18185, (DIND):18186,
(IND):18187, (10
36-1279):18188-18431, (1280-1284):1311235-1311239,
(1285-2059):1334197-1334971, (IND):1334972,
(2060-3083):1334973-1335996, (IND):13
35997, (3084-4107):1335998-1337021, (IND):1337022,
(4108-5131):1337023-1338046, (IND):1338047,
(5132-6155):1338048-1339071, (IND):13
39072, (6156-7179):1339073-1340096, (IND):1340097,
(7180-8203):1340098-1341121, (IND):1341122,
(8204-9227):1341123-1342146, (IND):13
42147, (9228-10251):1342148-1343171, (IND):1343172,
(10252-10566):1343173-1343487, (10567-11275):1344008-1344716,
(IND):1344717, (11
276-12299):1344718-1345741, (IND):1345742,
(12300-13323):1345743-1346766, (IND):1346767,
(13324-14347):1346768-1347791, (IND):134779
2, (14348-15371):1347793-1348816, (IND):1348817,
(15372-16395):1348818-1349841, (IND):1349842,
(16396-17419):1349843-1350866, (IND):
=2E..
debugfs:
debugfs:  stat mmap.1G
Inode: 14   Type: regular    Mode:  0644   Flags: 0x0
Generation: 1442185090    Version: 0x00000000
User:     0   Group:     0   Size: 1073741824
=46ile ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 1968016
=46ragment:  Address: 0    Number: 0    Size: 0
ctime: 0x4cb5d044 -- Wed Oct 13 17:29:08 2010
atime: 0x4cb5bf81 -- Wed Oct 13 16:17:37 2010
mtime: 0x4cb5d025 -- Wed Oct 13 17:28:37 2010
Size of extra inode fields: 4
BLOCKS:
(DIND):14336, (IND):14337, (16384-16395):14360-14371, (IND):14338,
(16396-16481):14372-14457, (16482-17153):14600-15271, (17154-1741
9):16520-16785, (IND):14339, (17420-17670):16786-17036,
(17671-17675):1081859-1081863, (17676-18443):1086089-1086856,
(IND):14340, (
18444-19467):1086857-1087880, (IND):14341,
(19468-20491):1087881-1088904, (IND):14342,
(20492-21515):1088905-1089928, (IND):14343, (
21516-22539):1089929-1090952, (IND):14344,
(22540-23563):1090953-1091976, (IND):14345,
(23564-24587):1091977-1093000, (IND):14346, (
24588-25611):1093001-1094024, (IND):14347,
(25612-26635):1094025-1095048, (IND):14348,
(26636-27659):1095049-1096072, (IND):14349, (
27660-28683):1096073-1097096, (IND):14472,
(28684-29707):1097097-1098120, (IND):15496,
(29708-30731):1098121-1099144, (IND):17544, (
30732-31755):1099145-1100168, (IND):17545,
(31756-32779):1100169-1101192, (IND):17546,
(32780-33803):1101193-1102216, (IND):17547, (
=2E..
debugfs:



Allocate file indirect blocks on page_mkwrite().

This is a sample patch to be merged with Jan Kara's ext3 delayed alloca=
tion
patches. Some of the code was taken from Jan's patches for testing only=
=2E
This patch is for kernel 2.6.35.6.

On page_mkwrite(), we allocate indirect blocks if needed and leave the =
data
blocks unallocated. Jan's patches take care of reserving space for the =
data.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

-----------------------------------------------------------------------=
---------
diff -Nuarp a/fs/buffer.c b/fs/buffer.c
--- a/fs/buffer.c	2010-10-13 17:42:06.472252298 +0200
+++ b/fs/buffer.c	2010-10-13 17:42:14.772244244 +0200
@@ -1687,8 +1687,9 @@ static int __block_write_full_page(struc
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
+								bh->b_blocknr);
 			}
 		}
 		bh =3D bh->b_this_page;
@@ -1873,7 +1874,8 @@ static int __block_prepare_write(struct
 			if (err)
 				break;
 			if (buffer_new(bh)) {
-				unmap_underlying_metadata(bh->b_bdev,
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
@@ -2592,7 +2594,7 @@ int nobh_write_begin_newtrunc(struct fil
 			goto failed;
 		if (!buffer_mapped(bh))
 			is_mapped_to_disk =3D 0;
-		if (buffer_new(bh))
+		if (buffer_new(bh) && buffer_mapped(bh))
 			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 		if (PageUptodate(page)) {
 			set_buffer_uptodate(bh);
diff -Nuarp a/fs/ext3/file.c b/fs/ext3/file.c
--- a/fs/ext3/file.c	2010-10-13 17:41:52.962541253 +0200
+++ b/fs/ext3/file.c	2010-10-13 17:42:25.083163556 +0200
@@ -52,6 +52,23 @@ static int ext3_release_file (struct ino
 	return 0;
 }

+static const struct vm_operations_struct ext3_file_vm_ops =3D {
+	.fault          =3D filemap_fault,
+	.page_mkwrite   =3D ext3_page_mkwrite,
+};
+
+static int ext3_file_mmap(struct file *file, struct vm_area_struct *vm=
a)
+{
+	struct address_space *mapping =3D file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops =3D &ext3_file_vm_ops;
+	vma->vm_flags |=3D VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext3_file_operations =3D {
 	.llseek		=3D generic_file_llseek,
 	.read		=3D do_sync_read,
@@ -62,7 +79,7 @@ const struct file_operations ext3_file_o
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	=3D ext3_compat_ioctl,
 #endif
-	.mmap		=3D generic_file_mmap,
+	.mmap		=3D ext3_file_mmap,
 	.open		=3D dquot_file_open,
 	.release	=3D ext3_release_file,
 	.fsync		=3D ext3_sync_file,
diff -Nuarp a/fs/ext3/inode.c b/fs/ext3/inode.c
--- a/fs/ext3/inode.c	2010-10-13 17:41:42.722231144 +0200
+++ b/fs/ext3/inode.c	2010-10-13 17:41:12.973180756 +0200
@@ -38,6 +38,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/mount.h>
 #include "xattr.h"
 #include "acl.h"

@@ -562,10 +563,17 @@ static int ext3_alloc_blocks(handle_t *h
 			count--;
 		}

-		if (count > 0)
+		if (index =3D=3D indirect_blks)
 			break;
 	}

+	if (blks =3D=3D 0) {
+		/* blks =3D=3D 0 when allocating only indirect blocks */
+		new_blocks[index] =3D 0;
+		*err =3D 0;
+		return 0;
+	}
+
 	/* save the new block number for the first direct block */
 	new_blocks[index] =3D current_block;

@@ -676,7 +684,9 @@ failed:
 	for (i =3D 0; i <indirect_blks; i++)
 		ext3_free_blocks(handle, inode, new_blocks[i], 1);

-	ext3_free_blocks(handle, inode, new_blocks[i], num);
+	if (num > 0)
+		/* num =3D=3D 0 when allocating only indirect blocks */
+		ext3_free_blocks(handle, inode, new_blocks[i], num);

 	return err;
 }
@@ -735,7 +745,8 @@ static int ext3_splice_branch(handle_t *
 	 * in i_block_alloc_info, to assist find the proper goal block for ne=
xt
 	 * allocation
 	 */
-	if (block_i) {
+	if (block_i && blks > 0) {
+		/* blks =3D=3D 0 when allocating only indirect blocks */
 		block_i->last_alloc_logical_block =3D block + blks - 1;
 		block_i->last_alloc_physical_block =3D
 				le32_to_cpu(where[num].key) + blks - 1;
@@ -778,7 +789,9 @@ err_out:
 		ext3_journal_forget(handle, where[i].bh);
 		ext3_free_blocks(handle,inode,le32_to_cpu(where[i-1].key),1);
 	}
-	ext3_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks);
+	if (blks > 0)
+		/* blks =3D=3D 0 when allocating only indirect blocks */
+		ext3_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks);

 	return err;
 }
@@ -905,6 +918,11 @@ int ext3_get_blocks_handle(handle_t *han

 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks =3D (chain + depth) - partial - 1;
+	if (indirect_blks + maxblocks =3D=3D 0) {
+		/* maxblocks =3D=3D 0 when allocating only indirect blocks */
+		mutex_unlock(&ei->truncate_mutex);
+		goto cleanup;
+	}

 	/*
 	 * Next look up the indirect map to count the totoal number of
@@ -929,7 +947,8 @@ int ext3_get_blocks_handle(handle_t *han
 		err =3D ext3_splice_branch(handle, inode, iblock,
 					partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
-	if (err)
+	if (err || count =3D=3D 0)
+		/* count =3D=3D 0 when allocating only indirect blocks */
 		goto cleanup;

 	set_buffer_new(bh_result);
@@ -981,6 +1000,9 @@ static int ext3_get_block(struct inode *
 		started =3D 1;
 	}

+	if (create < 0)
+		/* create < 0 when allocating only indirect blocks */
+		max_blocks =3D 0;
 	ret =3D ext3_get_blocks_handle(handle, inode, iblock,
 					max_blocks, bh_result, create);
 	if (ret > 0) {
@@ -1827,6 +1849,43 @@ out:
 }

 /*
+ * Reserve block writes instead of allocation. Called only on buffer h=
eads
+ * attached to a page (and thus for 1 block).
+ */
+static int ext3_da_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh, int create)
+{
+	int ret;
+
+	/* Buffer has already blocks reserved? */
+	if (buffer_delay(bh))
+		return 0;
+
+	/* passing -1 to allocate only indirect blocks */
+	ret =3D ext3_get_block(inode, iblock, bh, -1);
+	if (ret < 0)
+		return ret;
+	if (ret > 0 || !create)
+		return 0;
+	set_buffer_delay(bh);
+	set_buffer_new(bh);
+	return 0;
+}
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf=
)
+{
+	int retry =3D 0;
+	int ret;
+	struct super_block *sb =3D vma->vm_file->f_path.mnt->mnt_sb;
+
+	do {
+		ret =3D block_page_mkwrite(vma, vmf, ext3_da_get_block);
+	} while (ret =3D=3D VM_FAULT_SIGBUS &&
+			ext3_should_retry_alloc(sb, &retry));
+	return ret;
+}
+
+/*
  * Pages can be marked dirty completely asynchronously from ext3's jou=
rnalling
  * activity.  By filemap_sync_pte(), try_to_unmap_one(), etc.  We cann=
ot do
  * much here because ->set_page_dirty is called under VFS locks.  The =
page is
diff -Nuarp a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h	2010-10-13 17:49:26.892439258 +0200
+++ b/include/linux/ext3_fs.h	2010-10-13 17:49:10.662493115 +0200
@@ -909,6 +909,7 @@ extern void ext3_get_inode_flags(struct
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info =
*fieinfo,
 		       u64 start, u64 len);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fau=
lt *vmf);

 /* ioctl.c */
 extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
