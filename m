From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: A tool that allows changing inode table sizes
Date: Thu, 16 Jan 2014 17:05:45 -0700
Message-ID: <555DD664-E495-409D-9DAB-6E0A52C98273@dilger.ca>
References: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_1B59A948-45AC-460A-B588-23F217733F3C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: vitalif@yourcmc.ru
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61043 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaAQAFu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jan 2014 19:05:50 -0500
Received: by mail-pa0-f49.google.com with SMTP id hz1so3345082pad.22
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jan 2014 16:05:49 -0800 (PST)
In-Reply-To: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1B59A948-45AC-460A-B588-23F217733F3C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jan 15, 2014, at 6:28 AM, vitalif@yourcmc.ru wrote:
> As I understand it was a well-known fact that ext2/3/4 does not allow =
changing inode table size without recreating the filesystem. And I =
didn't have any experience in linux filesystem internals until recently, =
when I've discovered that inode tables take 45 GB on one of my hard =
drives (3 TB in size) :-):-) that hard drive is, of course, full of =
movies, not 16Kb files, so the inode tables are almost 100% unused.
>=20
> So, I've thought it would be good if it it would possible to change =
inode table sizes. So I've written a tool that in fact allows to do it, =
and I want to present it to the community! :)

Interesting.  I did something years ago for ext2/3 filesystem resizing
(ext2resize), but that has since become obsolete as the functionality
was included into e2fsprogs.  I'd recommend that you also work to get
your functionality included into e2fsprogs sooner rather than later.

Ideally this would be part of resize2fs, but I'm not sure it would be
easily implemented there.
=20
> Anyone is welcome to test it of course if it's of any interest for you =
- the source is here =
http://svn.yourcmc.ru/viewvc.py/vitalif/trunk/ext4-realloc-inodes/ =
('download tarball') (maybe it would be better to move it into a =
separate git repo, of course)
>=20
> I didn't test it on a real hard drive yet :-D, only on small fs images =
with different settings (block, block group, flex_bg size, ext2/3/4, =
bigalloc and etc). There are even some auto-tests (ran by 'make test').

Note that it is critical to refuse to do anything on filesystems that
have any feature that your tool doesn't understand.  Otherwise, it has
a good possibility to corrupt the filesystem.

> The tools works without problem on all small test images that I've =
created, though I didn't try to run it on bigger filesystems (of course =
I'll do it in the nearest future).
>=20
> As this is a highly destructive process that involves overwriting ALL =
inode numbers in ALL directory entries across the whole filesystem, I've =
also implemented a simple method of safely applying/rolling back =
changes. First I've tried to use undo_io_manager, but it appears to be =
very slow because of frequent commits, which are of course needed for it =
to be safe.

Would it be possible to speed up undo_io_manager if it had larger IO
groups or similar?  How does the speed of running with undo_io_manager
compare to running your patch_io_manager doing both a backup and apply?

> My method is called patch_io_manager and does a different thing - it =
does not overwrite the initial FS image, but writes all modified blocks =
into a separate sparse file + writes a bitmap of modified blocks in the =
end when it finishes. I.e. the initial filesystem stays unmodified.

This is essentially implementing a journal in userspace for e2fsprogs.
You could even use the journal file in the filesystem.  The journal
MUST be clean before the inode renumbering, or journal replay will
corrupt the filesystem after your resize.  Does your tool check this?

That said, there may not be enough space in the journal for full data
journaling, but it might be enough for logical journaling of the inodes
to be moved and the directories that need to be updated?

> Then, using e2patch utility (it's in the same repository), you can a) =
backup the blocks that will be modified into another patch file (e2patch =
backup <fs> <patch> <backup>) and b) apply the patch to real filesystem. =
If the applying process gets interrupted (for example by the power =
outage) it can be restarted from the beginning because it does nothing =
except just overwriting some blocks.

This is exactly like journal replay.

> And if the FS changes appear to be bad at all, you can restore the =
backup in a same way. So the process should be safe at least to some =
extent.

Looks interesting.  Of course, I always recommend doing a full backup
before any operation like this.  At that point, it would also be
possible to just format a new filesystem and copy the data over.  That
has the advantage of also allowing other filesystem features to be
enabled and defragmenting the data, but could be slower if the files
are large (as in your case) and relatively few inodes are moved.

Cheers, Andreas






--Apple-Mail=_1B59A948-45AC-460A-B588-23F217733F3C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUthz2nKl2rkXzB/gAQJdsBAAuBLuVmmu5y1bAOOck5YpRHy79tYHyPBE
T+Zw0fS2FWTvVP5lQKBLZkeOnvibHRz4PYeUfblMSk+l4i9n7JUZECdvXn99AhDe
p9Zy+Iv7QWWTf5vNbESSWCfUnxRFG0fYakZaug0HE1U5bNkxPiz8cNZ7HlhCJsMx
6+50+w+i7DaupClopy2Om8oTayHblY0nmj2DJhaR/+DKuVWnQb2XGaltf2WwUw24
d76Z3z/EylTmWp1K0DoL4uaB9Pw+wm4Bd+L9MDeObTJ1xOWq1lcF7Nb5gMPz+w9Y
8r5fKtBc5HVH3DNMv3zu+B2VzSht5kecqbcX4w6pHsMkPm92fgBrwjEjY63oNyd3
j8A4cHYhSgiG6rk6d7Vb/X8IkLFgq04eCBMzwpozXz4agNOGKWrK7CWqVYhcPo/l
41sHUwOMa+WW2EEaohiDQEgaB4CfO2XXnRGkvdbHUgsHSYOyR/W3IWpy4+kexImO
g+0scPhRTk155NjJP3RD8TEU/Ik/bezxxMrF/HMlJYRDwonvBuuBsDI7L3a6PPyg
0hDUjhiSP4rqY0bRcxMnov46nkoHsYdmWGp7FECfIgGnfQ2y045zHv8lLl3jDyf3
O96zuFjgEFbOufRmyZAKRxje3a6Kc+k5eyvDf7oreeMQvf2KHySqEDwpHseYNIiX
iyabWhdL2c4=
=V6XQ
-----END PGP SIGNATURE-----

--Apple-Mail=_1B59A948-45AC-460A-B588-23F217733F3C--
