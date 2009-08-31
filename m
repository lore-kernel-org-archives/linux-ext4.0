From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Mon, 31 Aug 2009 16:33:32 -0700
Message-ID: <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
References: <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
	 <20090828194051.GM4197@webber.adilger.int>
	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <20090828221432.GS4197@webber.adilger.int>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:28589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZHaXdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 19:33:35 -0400
Received: from spaceape12.eur.corp.google.com (spaceape12.eur.corp.google.com [172.28.16.146])
	by smtp-out.google.com with ESMTP id n7VNXZaN027219
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 00:33:36 +0100
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by spaceape12.eur.corp.google.com with ESMTP id n7VNXWNX010827
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:33:33 -0700
Received: by qw-out-1920.google.com with SMTP id 5so1058492qwc.6
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:33:32 -0700 (PDT)
In-Reply-To: <20090831215612.GG4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 2:56 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Aug 31, 2009 =A012:40 -0700, Jiaying Zhang wrote:
>> > It's better to define the flag as EXT4_KEEPSIZE_FL, and to use it =
as
>> > EXT4_KEEPSIZE_FL, but make a note of that bitfield position as bei=
ng
>> > reserved in include/linux/fs.h.
>>
>> Here is the modified patch based on your suggestions. I stick with t=
he
>> KEEPSIZE_FL approach that I think can allow us to handle the special
>> truncation accordingly during fsck. Other file systems can also re-u=
se
>> this flag when they want to support fallocate with KEEP_SIZE. As you
>> suggested, I moved the EXT4_KEEPSIZE_FL checking to ext4_setattr
>> that now calls vmtruncate if the KEEPSIZE flag is set in the i_flag.
>> Please let me know what you think about this proposed patch.
>>
>> --- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c =A0 2009-08-31
>> 12:08:10.000000000 -0700
>> +++ fs/ext4/extents.c 2009-08-31 12:12:16.000000000 -0700
>> @@ -3095,7 +3095,13 @@ static void ext4_falloc_update_inode(str
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, new_=
size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (new_size > EXT4_I(inode)->i_disksize=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_update_i_disksize(i=
node, new_size);
>> + =A0 =A0 =A0 =A0 =A0 =A0 inode->i_flags &=3D ~EXT4_KEEPSIZE_FL;
>
> Note that fallocate can be called multiple times for a file. =A0The
> EXT4_KEEPSIZE_FL should only be cleared if there were writes to
> the end of the fallocated space. =A0In that regard, I think the name
> of this flag should be changed to something like "EXT4_EOFBLOCKS_FL"
> to indicate that blocks are allocated beyond the end of file (i_size)=
=2E

Thanks for catching this! I changed the patch to only clear the flag
when the new_size is larger than i_size and changed the flag name
as you suggested. It would be nice if we only clear the flag when we
write beyond the fallocated space, but this seems hard to detect
because we no longer have the allocated size once that keepsize
fallocate call returns.

>
>> =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark that we allocate beyond EOF so t=
he subsequent truncate
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* can proceed even if the new size is t=
he same as i_size.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 inode->i_flags |=3D EXT4_KEEPSIZE_FL;
>
> Similarly, this should only be done in case the fallocate is actually
> beyond i_size. =A0While that is the most common case, it isn't necess=
arily
> ALWAYS going to be true (e.g. if multiple threads are calling falloca=
te()
> on a single file, or if a program always calls fallocate() on a file
> without first checking if the file size is large enough).

Also fixed.

>
>> +++ include/linux/fs.h =A0 =A0 =A0 =A02009-08-31 12:12:16.000000000 =
-0700
>> =A0#define FS_DIRECTIO_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x00100000 /* Use direct i/o */
>
>
>> +++ fs/ext4/ext4.h =A0 =A02009-08-31 12:12:16.000000000 -0700
>> =A0#define EXT4_EXT_MIGRATE =A0 =A0 =A0 =A0 =A0 =A0 0x00100000 /* In=
ode is migrating */
>
> Should we redefine EXT4_EXT_MIGRATE not to conflict with FS_DIRECTIO_=
=46L?
> I don't think much, if any, use has been made of this flag, and I can
> imagine a major headache in the future if this isn't changed now.
>
> Also, EXT4_EXT_MIGRATE doesn't necessarily belong in the i_flags spac=
e,
> since it is only used in-memory rather than on-disk as all of the oth=
ers
> are.

I will leave this out from my patch since it seems to belong to more ge=
neral
cleanup and I don't know much about the EXT4_EXT_MIGRATE flag :).

Here is the new patch:

--- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/extents.c	2009-08-31 15:51:13.000000000 -0700
@@ -3091,11 +3091,19 @@ static void ext4_falloc_update_inode(str
 	 * the file size.
 	 */
 	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
-		if (new_size > i_size_read(inode))
+		if (new_size > i_size_read(inode)) {
 			i_size_write(inode, new_size);
+			inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+		}
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
 	} else {
+		/*
+		 * Mark that we allocate beyond EOF so the subsequent truncate
+		 * can proceed even if the new size is the same as i_size.
+		 */
+		if (new_size > i_size_read(inode))
+			inode->i_flags |=3D EXT4_EOFBLOCKS_FL;
 	}
 }

--- .pc/fallocate_keepsizse.patch/fs/ext4/inode.c	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/inode.c	2009-08-31 15:50:56.000000000 -0700
@@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;

+	inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
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
+	     (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
 		handle_t *handle;

 		handle =3D ext4_journal_start(inode, 3);
@@ -4838,6 +4842,11 @@ int ext4_setattr(struct dentry *dentry,
 				goto err_out;
 			}
 		}
+		if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+			rc =3D vmtruncate(inode, attr->ia_size);
+			if (rc)
+				goto err_out;
+		}
 	}

 	rc =3D inode_setattr(inode, attr);
--- .pc/fallocate_keepsizse.patch/include/linux/fs.h	2009-08-31
12:08:10.000000000 -0700
+++ include/linux/fs.h	2009-08-31 16:21:44.000000000 -0700
@@ -343,6 +343,7 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_EOFBLOCKS_FL			0x00200000 /* Blocks allocated beyond EOF */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */

 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
--- .pc/fallocate_keepsizse.patch/fs/ext4/ext4.h	2009-08-31
12:08:10.000000000 -0700
+++ fs/ext4/ext4.h	2009-08-31 15:52:34.000000000 -0700
@@ -235,6 +235,7 @@ struct flex_groups {
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge=
 file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
+#define EXT4_EOFBLOCKS_FL		0x00200000 /* Blocks allocated beyond EOF
(bit reserved in fs.h) */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */

 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
root@outpost:/mnt/work/linux-2.6.30.5#

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
