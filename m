From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 2 Sep 2009 22:20:31 -0700
Message-ID: <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <20090828194051.GM4197@webber.adilger.int>
	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <20090828221432.GS4197@webber.adilger.int>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
	 <20090902084134.GO4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:27768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZICFUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:20:33 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n835KYbc005343
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 22:20:34 -0700
Received: from qyk8 (qyk8.prod.google.com [10.241.83.136])
	by wpaz29.hot.corp.google.com with ESMTP id n835KVYa006232
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 22:20:32 -0700
Received: by qyk8 with SMTP id 8so807040qyk.2
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 22:20:31 -0700 (PDT)
In-Reply-To: <20090902084134.GO4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 1:41 AM, Andreas Dilger<adilger@sun.com> wrote:
> On Aug 31, 2009 =A016:33 -0700, Jiaying Zhang wrote:
>> > EXT4_KEEPSIZE_FL should only be cleared if there were writes to
>> > the end of the fallocated space. =A0In that regard, I think the na=
me
>> > of this flag should be changed to something like "EXT4_EOFBLOCKS_F=
L"
>> > to indicate that blocks are allocated beyond the end of file (i_si=
ze).
>>
>> Thanks for catching this! I changed the patch to only clear the flag
>> when the new_size is larger than i_size and changed the flag name
>> as you suggested. It would be nice if we only clear the flag when we
>> write beyond the fallocated space, but this seems hard to detect
>> because we no longer have the allocated size once that keepsize
>> fallocate call returns.
>
> The problem is that if e2fsck depends on the EXT4_EOFBLOCKS_FL set
> for fallocate-beyond-EOF then it is worse to clear it than to leave
> it set. =A0At worst, leaving the flag set results in too many truncat=
es
> on the file. =A0Clearing the flag when not correct may result in user
> visible data corruption if the file size is extended...
>
>> Here is the new patch:
>>
>> --- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c =A0 2009-08-31
>> 12:08:10.000000000 -0700
>> +++ fs/ext4/extents.c 2009-08-31 15:51:13.000000000 -0700
>> @@ -3091,11 +3091,19 @@ static void ext4_falloc_update_inode(str
>> =A0 =A0 =A0 =A0* the file size.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (new_size > i_size_read(inode)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, new_=
size);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_flags &=3D ~EXT4_=
EOFBLOCKS_FL;
>
> This again isn't quite correct, since the EOFBLOCKS_FL shouldn't
> be cleared unless new_size is beyond the allocated size. =A0The
> allocation code itself might be a better place to clear this,
> since it knows whether there were new blocks being added beyond
> the current max allocated block.

We were thinking to clear this flag when we need to allocate new
blocks, but I was not sure how to get the current max allocated
block -- that is mostly because I just started working on the ext4
code. After digging into the ext4 allocation code today, I think we
can put the check&clear in ext4_ext_get_blocks:

@@ -2968,6 +2968,14 @@ int ext4_ext_get_blocks(handle_t *handle
 	newex.ee_len =3D cpu_to_le16(ar.len);
 	if (create =3D=3D EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitializ=
ed */
 		ext4_ext_mark_uninitialized(&newex);
+
+	if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+		BUG_ON(!eh->eh_entries);
+		last_ex =3D EXT_LAST_EXTENT(eh);
+		if (iblock + max_blocks > le32_to_cpu(last_ex->ee_block)
+					+ ext4_ext_get_actual_len(last_ex))
+			inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+	}
 	err =3D ext4_ext_insert_extent(handle, inode, path, &newex);
 	if (err) {
 		/* free data blocks we just allocated */

Again, I just started looking at this part of code, so please let me kn=
ow
if I am in the right direction.

Another thing I am not sure is whether we can allocate a non-data block=
,
like extended attributes, beyond the current max block without changing
the i_size. In that case, clearing the EOFBLOCKS flag will be wrong.

>> =A0#define FS_FL_USER_VISIBLE =A0 =A0 =A0 =A0 =A0 0x0003DFFF /* User=
 visible flags */
>
> It probably isn't a bad idea to make this flag user-visible, since it
> would allow scanning for files that have excess space reserved (e.g.
> if the filesystem is getting full). =A0Making it user-settable (i.e.
> clearable) would essentially mean truncating the file to i_size witho=
ut
> updating the timestamps so that the reserved space is discarded. =A0I
> don't think there is any value in allowing a user to turn this flag o=
n
> for a file.

So to make it user-settable, we need to add the handling in ext4_ioctl
that calls vmtruncate when the flag to be cleared. But how can we get
the right size to truncate in that case? Can we just set that to the
max initialized block shift with block size? But that may also truncate
the blocks reserved without the KEEP_SIZE flag.

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
