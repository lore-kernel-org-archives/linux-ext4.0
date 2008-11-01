From: "Michael B. Trausch" <mike@trausch.us>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Sat, 1 Nov 2008 19:46:17 -0400
Message-ID: <20081101194617.0dc131c3@zest>
References: <20081101151002.4ed9be99@zest>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kj=AVJuy5oqBAzCfRXnyK0g";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:63312 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYKAXqz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Nov 2008 19:46:55 -0400
Received: by yw-out-2324.google.com with SMTP id 9so780318ywe.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Nov 2008 16:46:53 -0700 (PDT)
In-Reply-To: <20081101151002.4ed9be99@zest>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/Kj=AVJuy5oqBAzCfRXnyK0g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Nov 2008 15:10:02 -0400
"Michael B. Trausch" <mike@trausch.us> wrote:
>
> I converted my home directory to ext4 without issue and so I
> (stupidly, I admit) did not take a backup of this 250 GB drive's
> contents before I started the conversion process.  Oops.  Lesson
> learned.  My thinking at this point is that it would take _far_ less
> time to interrupt, backup, and just use mkfs.ext4 on the drive and
> then restore (about 2 hours instead of an unknown quantity which is
> already nearing 13 hours).
>=20

At 18:01:34 (after 15 hours and change) I decided to give it up and
sent tune2fs a SIGINT.  It happily aborted, and fsck appears to have
fixed whatever inconsistencies were introduced during the tune2fs run
and the files on the volume appear to be perfectly intact.

Am going to go the route of simply pulling the data off and using
mkfs.ext4 to create a new filesystem on the device.  But, I am still
curious as to why this would run for so long.  Some volume statistics,
in case they may be of help in trying to determine why this process was
running for so long; I don't even know how much longer it would have
run for.

Stats from fsck:
  651384 inodes used (4.27%)
     788 non-contiguous inodes (0.1%)
         # of inodes with ind/dind/tind blocks: 27974/1745/8
28464107 blocks used (46.62%)
       0 bad blocks
      14 large files

  553474 regular files
   90764 directories
       0 character device files
       0 block device files
       0 fifos
       3 links
    7136 symbolic links (7093 fast symbolic links)
       1 socket
--------
  651378 files

Stats from dumpe2fs:
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          95904edb-b501-4c3c-9bec-b9f046b04e3b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery sparse_super large_file Filesystem
flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              15269888
Block count:              61049596
Reserved block count:     3052479
Free blocks:              32585489
Free inodes:              14618504
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1009
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   256
Filesystem created:       Mon Jul  7 23:09:06 2008
Last mount time:          Sat Nov  1 18:20:45 2008
Last write time:          Sat Nov  1 18:20:45 2008
Mount count:              1
Maximum mount count:      27
Last checked:             Sat Nov  1 18:18:24 2008
Check interval:           15552000 (6 months)
Next check after:         Thu Apr 30 18:18:24 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      52aba0f3-6da7-4e1a-b4b3-e8c51e8168fc
Journal backup:           inode blocks
Journal size:             128M

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/Kj=AVJuy5oqBAzCfRXnyK0g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkM6kkACgkQ0kE/IBnFmjAViACfcvy5sSIuwWPej6xXT6Z9ECCf
2NsAoIMUXbAlR5Jz1r10P01sxl7TLPew
=LiV/
-----END PGP SIGNATURE-----

--Sig_/Kj=AVJuy5oqBAzCfRXnyK0g--
