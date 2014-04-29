From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Tue, 29 Apr 2014 11:22:13 -0400
Message-ID: <20140429152213.GF5136@gradx.cs.jhu.edu>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Cc: linux-ext4@vger.kernel.org, admins@acm.jhu.edu
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:60178 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaD2PWW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 11:22:22 -0400
Content-Disposition: inline
In-Reply-To: <20140423143642.GA29925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 10:36:42AM -0400, Theodore Ts'o wrote:
> OK, with the two of you reporting this problem, can you do me the
> following so we can try to seriously dig into this:
>[snip]

Just got another instance of corruption; this time on the allocation side:
[715863.874936] EXT4-fs error (device vdb): ext4_mb_generate_buddy:756: group 50737, 485 clusters in bitmap, 484 in gd; block bitmap corrupt.

This time from a different, though still > 8TB filesystem, whose dump
information sayeth:

Filesystem volume name:   <none>
Last mounted on:          /viceps
Filesystem UUID:          5bd1df60-53df-43f9-9785-5a35da485c81
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              335544320
Block count:              2684354560
Reserved block count:     134217728
Free blocks:              1767616367
Free inodes:              328163234
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      384
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         4096
Inode blocks per group:   256
RAID stride:              1024
RAID stripe width:        1024
Flex block group size:    16
Filesystem created:       Fri Jan 24 18:01:34 2014
Last mount time:          Sun Apr 20 14:08:10 2014
Last write time:          Tue Apr 29 11:16:22 2014
Mount count:              5
Maximum mount count:      -1
Last checked:             Wed Apr  9 17:39:32 2014
Check interval:           0 (<none>)
Lifetime writes:          3574 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      d51561e1-73f7-40c6-bfac-61d8e46a4da4
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x000ab65b
Journal start:            0

Cheers,
--nwf;

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNfw6UACgkQTeQabvr9Tc9JpwCfdzy6ITM0EZqOF5jCQdvDQC2p
7AUAn0lfUvWMDHC/Os7zC7l0NlXJT8Kp
=O9w0
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
