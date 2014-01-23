From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 12/12] mke2fs: allow metadata blocks to be at the beginning of the file system
Date: Thu, 23 Jan 2014 14:28:43 -0700
Message-ID: <5C95CFF5-8E64-4EF5-B4E5-A7579FE79B64@dilger.ca>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu> <1390197254-14583-13-git-send-email-tytso@mit.edu> <ACF77779-7A44-4ED7-BC49-7658A8DF8514@dilger.ca> <20140121062351.GA23185@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_57CC0459-33E8-4F36-BC3C-2B50F5310FFF"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47021 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaAWV2v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2014 16:28:51 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so2277602pdj.25
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jan 2014 13:28:51 -0800 (PST)
In-Reply-To: <20140121062351.GA23185@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_57CC0459-33E8-4F36-BC3C-2B50F5310FFF
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 20, 2014, at 11:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jan 20, 2014 at 04:25:23PM -0700, Andreas Dilger wrote:
>> The "packed_meta_blocks" appears to be equivalent to setting flex_bg
>> to some large enough factor that all the block and inode bitmaps are
>> at the start of the filesystem?
> 
> It's not the same thing, unfortunately, because of how we make room
> for the file system to grow and so require extra room for potential
> new block groups.  Try running "mke2fs -t ext4 -G 262144 /tmp/foo.img
> 1T" and look at the gaps between the allocation bitmaps and the inode
> table using dumpe2fs.

I'd consider that a potential benefit, since it would allow the
filesystem to be resized at a later point.  However, it does mean
that if there is a big difference between the original filesystem
size and the maximum size that the intervening blocks would need
to be reserved blocks so they do not get allocated in the meantime
(e.g. allocated by the resize inode or something?).

I actually tested with "mke2fs -t ext4 -G 131072 -i 1048576"
(16TB max size, 1MB per inode, mke2fs 1.42.7.wc1) to see what the
on-disk layout is like.  It seems a bug in inode table allocation
gives a bad layout.  It starts out as expected, planning for 4 full
groups of block bitmaps (4 groups * 32K blocks/group = 131072 bitmaps)
from group #0 to #3, then 4 full groups of inode bitmaps from group
#4 to #7, and finally inode tables starting at group #8 onward (but
note I don't think it takes backup group descriptors into account):

  Group 0: (Blocks 0-32767)
    Primary superblock at 0, Group descriptors at 1-2048
    Block bitmap 2049 (+2049), Inode bitmap at 133121 (bg #4+2049)
    Inode table 264193-264200 (bg #8+2049)

However, things go badly when the inode tables fill up their first
block group.  For some reason, the inode table allocations wrap
around to group #0 instead of continuing in group #9, which screws
up the block bitmap allocations and they start getting interleaved
with the inode table:

  Group 3838: (Blocks 125763584-125796351) [INODE_UNINIT, BLOCK_UNINIT]
    Block bitmap 5887 (bg #0+5887), Inode bitmap 136959 (bg #4+5887)
    Inode table 294897-294904 (bg #8 + 32753)
  Group 3839: (Blocks 125796352-125829119) [INODE_UNINIT, BLOCK_UNINIT]
    Block bitmap 5888 (bg #0+5888), Inode bitmap 136960 (bg #4+5888)
    Inode table 5889-5896 (bg #0 + 5889)
  Group 3840: (Blocks 125829120-125861887) [INODE_UNINIT, BLOCK_UNINIT]
    Block bitmap 5897 (bg #0+5897), Inode bitmap 136961 (bg #4+5889)
    Inode table 5898-5905 (bg #0 + 5898)

This eventually screws up all of the flex_bg allocations and it is
not really much better than non-flex_bg for the rest of the filesystem.
It looks like the problem for the group #3839 inode table is because
it runs into the backup superblock and group descriptors in group #9:

  Group 9: (Blocks 294912-327679) [INODE_UNINIT]
    Backup superblock at 294912, Group descriptors at 294913-296960

I tried digging through the code to see where it went wrong, and it
looks like ext2fs_allocate_group_table->flexbg_offset().tic code is
failing when it doesn't find an empty range, and then resets the
start block to the first group in the flex_bg (== 0):

57      if (start_blk && ext2fs_test_block_bitmap_range2(bmap, start_blk,
58                                                       elem_size))
59              return start_blk;
60
61      start_blk = ext2fs_group_first_block2(fs, flexbg_size * flexbg);

It would be interesting to test this in conjunction with sparse_super2
and put the first backup group descriptor in group #49 (after the inode
table) and see if it can get an ideal flex_bg layout.

I might have a patch that can fix this without too much effort, not
sure yet.

Cheers, Andreas

>> It would probably be better to align
>> the inode and block bitmaps and inode table on a multiple of
>> s_raid_stride (will this be used to align on SMR erase blocks?) so
>> that rewrites are at least somewhat efficient and aligned?  That would
>> also allow reserving some room in the flex_bg packing to allow for
>> filesystem resizing.
> 
> Given these blocks are written using random 4k writes, I don't think
> any kind of alignment is going to be worth it.
> 
>> It would also be useful to allow setting the journal goal block
>> directly, instead of journal_location_front only allowing to specify
>> goal == 0 (i.e. add "-E journal_start_goal=N" instead of adding
>> "-E journal_location_front", which implied by packed_meta_blocks).
>> I've wanted to be able to do this for a long time, but the stumbling
>> block is that write_journal_inode() doesn't have any parameter to
>> specify the goal journal block without storing it in the superblock.
>> I suppose it would be possible to pass the journal goal block in
>> s_jnl_blocks[0..1] or something?
> 
> Hmm, yes, adding a flag which indicates that the starting block should
> be passed in s_jnl_blocks[0] is a good idea.
> 
> 					- Ted


Cheers, Andreas






--Apple-Mail=_57CC0459-33E8-4F36-BC3C-2B50F5310FFF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUuGJjHKl2rkXzB/gAQIdihAAvFen2yzgX7j3pMyLwD3Z/2XLX0C6eOdV
vSZat0Rqb68Szx3y6z8+MBloABm+7d4enfglz8/zplYdxYGI6PTQAraoi3BZv1An
/7kZDmqJlMJ5DV7KYVghdLAE0weGaEEBhD7KdEroS3mcduH+ttp1RTxcTN4bUKxP
/lxcCLrQhfIPhcG9s3SVatFQ6gSFpESq3lNDtFqhFAdoruCJt/AAdZTICJEAandS
RgLLIb6vEJyPt801m0q0CxrIK4rniiBHXTpdCzGt9kA4i2rATrDxbw2LAl6dS+ky
767eDejK/vVii+e/gAK0madbRKlRzKjZH6xlPTLWgkNGfcOqyEJJiYwdpOrkf0bF
9pito9UUc4ZTFBVzBgKKn7XDOwj3EuuZHR8DaxaMgmD+tWmoyYiKf2+M7RKG4P62
LFTOnClmRCet6h8m8wsBJR9ylf93IhBpt9Vkpy8qYcWrI/75ca6XbcYmDnlbjOZT
qBMgoOpaN+P0i78eAweGGJUjdm5RNODtt+jHgC7GG2mVzmfcD5yMxypEtyDfK0bq
PHhYZxuhIl14qwSkJWRe5gxampKDwF6OBBRv3Dr8AWtmeytsEJ/rycyy57JeaW0s
b8OJyBwRJbVrSUzn4mdJCQMAtyDP6cQJqXm6vWo1sKDlBpfi0FJaYWoXOe6beK02
N70tscOY5Vg=
=lwSr
-----END PGP SIGNATURE-----

--Apple-Mail=_57CC0459-33E8-4F36-BC3C-2B50F5310FFF--
