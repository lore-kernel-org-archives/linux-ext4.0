From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 02 Sep 2009 02:41:34 -0600
Message-ID: <20090902084134.GO4197@webber.adilger.int>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
 <20090828194051.GM4197@webber.adilger.int>
 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
 <20090828221432.GS4197@webber.adilger.int>
 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
 <20090830025250.GA25768@mit.edu>
 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
 <20090831215612.GG4197@webber.adilger.int>
 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62797 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZIBIlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 04:41:24 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n828fQ2J018608
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 01:41:26 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPC008005BO0Q00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 01:41:26 -0700 (PDT)
In-reply-to: <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  16:33 -0700, Jiaying Zhang wrote:
> > EXT4_KEEPSIZE_FL should only be cleared if there were writes to
> > the end of the fallocated space. =A0In that regard, I think the nam=
e
> > of this flag should be changed to something like "EXT4_EOFBLOCKS_FL=
"
> > to indicate that blocks are allocated beyond the end of file (i_siz=
e).
>=20
> Thanks for catching this! I changed the patch to only clear the flag
> when the new_size is larger than i_size and changed the flag name
> as you suggested. It would be nice if we only clear the flag when we
> write beyond the fallocated space, but this seems hard to detect
> because we no longer have the allocated size once that keepsize
> fallocate call returns.

The problem is that if e2fsck depends on the EXT4_EOFBLOCKS_FL set
for fallocate-beyond-EOF then it is worse to clear it than to leave
it set.  At worst, leaving the flag set results in too many truncates
on the file.  Clearing the flag when not correct may result in user
visible data corruption if the file size is extended...

> Here is the new patch:
>=20
> --- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c	2009-08-31
> 12:08:10.000000000 -0700
> +++ fs/ext4/extents.c	2009-08-31 15:51:13.000000000 -0700
> @@ -3091,11 +3091,19 @@ static void ext4_falloc_update_inode(str
>  	 * the file size.
>  	 */
>  	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +		if (new_size > i_size_read(inode)) {
>  			i_size_write(inode, new_size);
> +			inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;

This again isn't quite correct, since the EOFBLOCKS_FL shouldn't
be cleared unless new_size is beyond the allocated size.  The
allocation code itself might be a better place to clear this,
since it knows whether there were new blocks being added beyond
the current max allocated block.

> +#define FS_EOFBLOCKS_FL			0x00200000 /* Blocks allocated beyond EOF =
*/
>  #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
>=20
>  #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */

It probably isn't a bad idea to make this flag user-visible, since it
would allow scanning for files that have excess space reserved (e.g.
if the filesystem is getting full).  Making it user-settable (i.e.
clearable) would essentially mean truncating the file to i_size without
updating the timestamps so that the reserved space is discarded.  I
don't think there is any value in allowing a user to turn this flag on
for a file.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
