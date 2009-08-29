From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 28 Aug 2009 17:40:54 -0700
Message-ID: <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
References: <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <4A689723.7000805@redhat.com>
	 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <20090723215614.GF4231@webber.adilger.int>
	 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
	 <20090828194051.GM4197@webber.adilger.int>
	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <20090828221432.GS4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:3994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZH2Ak5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 20:40:57 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n7T0evMt005993
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2009 01:40:58 +0100
Received: from qyk9 (qyk9.prod.google.com [10.241.83.137])
	by zps36.corp.google.com with ESMTP id n7T0esEn009473
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 17:40:55 -0700
Received: by qyk9 with SMTP id 9so1499039qyk.15
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 17:40:54 -0700 (PDT)
In-Reply-To: <20090828221432.GS4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2009 at 3:14 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Aug 28, 2009 =A014:44 -0700, Jiaying Zhang wrote:
>> On Fri, Aug 28, 2009 at 12:40 PM, Andreas Dilger<adilger@sun.com> wr=
ote:
>> > This isn't really correct, however, because i_blocks also contains
>> > non-data blocks (indirect/index, EA, etc) blocks, so even with sma=
ll
>> > files with ACLs i_blocks may always be larger than ia_size >> 9, a=
nd
>> > for ext2/3 at least this will ALWAYS be true for files > 48kB in s=
ize.
>>
>> I see. I guess we need to use a special flag then. Or is there any
>> other suggestions? I also have another question related to this
>> problem. Why those fallocated blocks are not marked as preallocated
>> blocks that will then be automatically freed in ext4_release_file?
>
> Because fallocate() means "persistent allocation on disk", not "in me=
mory
> preallocation". =A0The "in memory" preallocation already happens in e=
xt4,
> and it is released when the inode is cleaned up.

Right. Thanks for pointing this out!

RFC, here is a patch that Frank and I have been working on. It introduc=
es
a new fs flag to mark that the file has been allocated beyond its EOF, =
as
discussed previously in this thread. The flag is cleared in the subsequ=
ent
vmtruncate or fallocate without KEEPSIZE. It is possible that a vmtrunc=
ate
may be called unnecessarily in the case that the file is written beyond=
 the
allocated size, but I think it is ok to pay this cost to get correctnes=
s.

--- .pc/fallocate_keepsizse.patch/fs/attr.c	2009-08-28 15:38:46.0000000=
00 -0700
+++ fs/attr.c	2009-08-28 17:01:04.000000000 -0700
@@ -68,7 +68,8 @@ int inode_setattr(struct inode * inode,
 	unsigned int ia_valid =3D attr->ia_valid;

 	if (ia_valid & ATTR_SIZE &&
-	    (attr->ia_size !=3D i_size_read(inode)) {
+	    (attr->ia_size !=3D i_size_read(inode) ||
+	     (inode->i_flags & FS_KEEPSIZE_FL))) {
 		int error =3D vmtruncate(inode, attr->ia_size);
 		if (error)
 			return error;
--- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c	2009-08-28
15:37:45.000000000 -0700
+++ fs/ext4/extents.c	2009-08-28 17:27:27.000000000 -0700
@@ -3095,7 +3095,13 @@ static void ext4_falloc_update_inode(str
 			i_size_write(inode, new_size);
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
+		inode->i_flags &=3D ~FS_KEEPSIZE_FL;
 	} else {
+		/*
+		 * Mark that we allocate beyond EOF so the subsequent truncate
+		 * can proceed even if the new size is the same as i_size.
+		 */
+		inode->i_flags |=3D FS_KEEPSIZE_FL;
 	}
 }

--- .pc/fallocate_keepsizse.patch/fs/ext4/inode.c	2009-08-16
14:19:38.000000000 -0700
+++ fs/ext4/inode.c	2009-08-28 16:59:42.000000000 -0700
@@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;

+	inode->i_flags &=3D ~FS_KEEPSIZE_FL;
+
 	if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC=
))
 		ei->i_state |=3D EXT4_STATE_DA_ALLOC_CLOSE;

--- .pc/fallocate_keepsizse.patch/include/linux/fs.h	2009-08-28
15:44:27.000000000 -0700
+++ include/linux/fs.h	2009-08-28 17:00:47.000000000 -0700
@@ -343,6 +343,7 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_KEEPSIZE_FL			0x00200000 /* Blocks allocated beyond EOF */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */

 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */

Jiaying

>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
