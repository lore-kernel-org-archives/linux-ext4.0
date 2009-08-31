From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Mon, 31 Aug 2009 12:40:29 -0700
Message-ID: <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
References: <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <20090723215614.GF4231@webber.adilger.int>
	 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
	 <20090828194051.GM4197@webber.adilger.int>
	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <20090828221432.GS4197@webber.adilger.int>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:56766 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZHaTks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 15:40:48 -0400
Received: from spaceape14.eur.corp.google.com (spaceape14.eur.corp.google.com [172.28.16.148])
	by smtp-out.google.com with ESMTP id n7VJemwi026032
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 20:40:48 +0100
Received: from qw-out-2122.google.com (qwi5.prod.google.com [10.241.195.5])
	by spaceape14.eur.corp.google.com with ESMTP id n7VJejc7031634
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 12:40:45 -0700
Received: by qw-out-2122.google.com with SMTP id 5so1333918qwi.51
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 12:40:45 -0700 (PDT)
In-Reply-To: <20090830025250.GA25768@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot for the comments and suggestions!

On Sat, Aug 29, 2009 at 7:52 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Aug 28, 2009 at 05:40:54PM -0700, Jiaying Zhang wrote:
>> --- .pc/fallocate_keepsizse.patch/fs/attr.c =A0 2009-08-28 15:38:46.=
000000000 -0700
>> +++ fs/attr.c 2009-08-28 17:01:04.000000000 -0700
>> @@ -68,7 +68,8 @@ int inode_setattr(struct inode * inode,
>> =A0 =A0 =A0 unsigned int ia_valid =3D attr->ia_valid;
>>
>> =A0 =A0 =A0 if (ia_valid & ATTR_SIZE &&
>> - =A0 =A0 =A0 =A0 (attr->ia_size !=3D i_size_read(inode)) {
>> + =A0 =A0 =A0 =A0 (attr->ia_size !=3D i_size_read(inode) ||
>> + =A0 =A0 =A0 =A0 =A0(inode->i_flags & FS_KEEPSIZE_FL))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int error =3D vmtruncate(inode, attr->ia=
_size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
>
> Instead of doing this in the generic code, it really should be done i=
n
> ext4_setattr. =A0Technically speaking, we don't actually need the
> FS_KEEPSIZE_FL to solve this problem; instead we can simply have the
> ext4 code look in the extent tree to see if there are any blocks
> mapped beyond the logical block:
>
> =A0 =A0 =A0 i_size_read(inode) >> inode->i_sb->s_blocksize_bits

Is it relatively cheap to scan the extent tree? Will this add the
overhead to truncate?

>
> Having a flag as Andreas suggested does help with the issue of e2fsck
> noticing whether or not i_size is incorrect (and should be fixed) or
> the file has been extended. =A0So keeping having the flag is an OK th=
ing
> to do, but we need to be careful about a particularly subtle
> overloading problem. =A0The flags FS_*_FL as defined in
> include/linux/fs.h are technically only for in-memory use. =A0The ext=
4
> on-disk format flags is EXT4_*_FL, and defined in ext4.h.
>
> The flags were originially defined for use in ext2/3/4, but later on
> other filesystems adopted those flags so that e2fsprogs's chattr and
> lsattr programs could be used for their filesystems as well. =A0It ju=
st
> so happens that for ext2/3/4 the on-disk encoding of those flags in
> the in-memory encoding of those flags in i_flags are the same, but
> that means that the flags need to be defined in both places to avoid
> assignment overlaps. =A0We also need to be clear whether the flags ar=
e
> internal flags for ext4's use only, or flags meant for use by all
> filesystems. =A0This is why the testing for FS_KEEPSIZE_FL in fs/attr=
 is
> particularly bad, if the flag are going to be set in fs/ext4/extents.=
c.
>
> It's better to define the flag as EXT4_KEEPSIZE_FL, and to use it as
> EXT4_KEEPSIZE_FL, but make a note of that bitfield position as being
> reserved in include/linux/fs.h.

Here is the modified patch based on your suggestions. I stick with the
KEEPSIZE_FL approach that I think can allow us to handle the special
truncation accordingly during fsck. Other file systems can also re-use
this flag when they want to support fallocate with KEEP_SIZE. As you
suggested, I moved the EXT4_KEEPSIZE_FL checking to ext4_setattr
that now calls vmtruncate if the KEEPSIZE flag is set in the i_flag.
Please let me know what you think about this proposed patch.

Thanks a lot!

Jiaying

--- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/extents.c	2009-08-31 12:12:16.000000000 -0700
@@ -3095,7 +3095,13 @@ static void ext4_falloc_update_inode(str
 			i_size_write(inode, new_size);
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
+		inode->i_flags &=3D ~EXT4_KEEPSIZE_FL;
 	} else {
+		/*
+		 * Mark that we allocate beyond EOF so the subsequent truncate
+		 * can proceed even if the new size is the same as i_size.
+		 */
+		inode->i_flags |=3D EXT4_KEEPSIZE_FL;
 	}
 }

--- .pc/fallocate_keepsizse.patch/fs/ext4/inode.c	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/inode.c	2009-08-31 12:12:16.000000000 -0700
@@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;

+	inode->i_flags &=3D ~EXT4_KEEPSIZE_FL;
+
 	if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC=
))
 		ei->i_state |=3D EXT4_STATE_DA_ALLOC_CLOSE;

@@ -4807,7 +4809,9 @@ int ext4_setattr(struct dentry *dentry,
 	}

 	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
+	    attr->ia_valid & ATTR_SIZE &&
+	    (attr->ia_size < inode->i_size ||
+	     (inode->i_flags & EXT4_KEEPSIZE_FL))) {
 		handle_t *handle;

 		handle =3D ext4_journal_start(inode, 3);
@@ -4838,6 +4842,11 @@ int ext4_setattr(struct dentry *dentry,
 				goto err_out;
 			}
 		}
+		if ((inode->i_flags & EXT4_KEEPSIZE_FL)) {
+			rc =3D vmtruncate(inode, attr->ia_size);
+			if (rc)
+				goto err_out;
+		}
 	}

 	rc =3D inode_setattr(inode, attr);
--- .pc/fallocate_keepsizse.patch/include/linux/fs.h	2009-08-31
12:08:10.000000000 -0700
+++ include/linux/fs.h	2009-08-31 12:12:16.000000000 -0700
@@ -343,6 +343,7 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_KEEPSIZE_FL			0x00200000 /* Blocks allocated beyond EOF */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */

 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
--- .pc/fallocate_keepsizse.patch/fs/ext4/ext4.h	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/ext4.h	2009-08-31 12:12:16.000000000 -0700
@@ -235,6 +235,7 @@ struct flex_groups {
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge=
 file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
+#define EXT4_KEEPSIZE_FL		0x00200000 /* Blocks allocated beyond EOF
(bit reserved in fs.h) */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */

 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */


>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
