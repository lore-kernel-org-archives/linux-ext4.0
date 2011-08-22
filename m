From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext2fs_test_block_bitmap (): Unknown code ext2 47 #0, etc.
Date: Mon, 22 Aug 2011 00:31:03 -0400
Message-ID: <20110822043103.GB3671@thunk.org>
References: <86ei0p8ve2.fsf@gray.siamics.net>
 <alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
 <86zkjb3p7f.fsf@gray.siamics.net>
 <alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
 <86ei0k1tbc.fsf@gray.siamics.net>
 <867h6awuq5.fsf_-_@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51978 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1HVFNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 01:13:35 -0400
Content-Disposition: inline
In-Reply-To: <867h6awuq5.fsf_-_@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 11:27:30PM +0700, Ivan Shmakov wrote:
> >>>>> Ivan Shmakov <ivan@gray.siamics.net> writes:
>=20
> [=E2=80=A6]
>=20
>  > (The support for the whole-image and metadata message digests is n=
ot
>  > yet committed.)
>=20
> 	The code is now ready to be committed.  However, I'm getting the
> 	following message on stderr upon a call (only the first one?) to
> 	ext2fs_test_block_bitmap ():
>=20
> --cut--
> Unknown code ext2 47 #0 for block bitmap for /dev/stdin
> --cut--

You're not getting a human-readable error message because you need to
add the following at the beginning of your program:

	add_error_table(&et_ext2_error_table);

(The error messages are printed by the libcom_err library, and are
defined in lib/ext2fs/ext2_err.et.in, processed to
lib/ext2fs/ext2_err.et, and then compiled to ext2_err.c and ext2_err.h
by the compile_et script in lib/et of e2fsprogs.)

The 47th error message in the ext2 error table, which would have been
printed if you had called add_error_table(), is:

	Illegal block number passed to ext2fs_test_block_bitmap

This means you've passed in a block number which is out-of-range for
the block bitmap.

> 	Also, do I understand it correctly that I need to call
> 	ext2fs_read_block_bitmap () before accessing the block_map
> 	member of the ext2_filsys structure?

Yes, or if you are going to need to read in both the block and inode
bitmaps, you can use ext2fs_read_bitmaps(), which will be more optimal
for reading in the block bitmaps.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
