From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] Add support for new compat feature "super_sparse"
Date: Thu, 16 Jan 2014 13:21:47 -0700
Message-ID: <9E6FFD6C-D0E8-4B2D-A6F6-9835F6001786@dilger.ca>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu> <20140113132707.GA22358@orion.maiolino.org> <20140113140645.GC18029@thunk.org> <20140113161949.GB22541@thunk.org> <20140114055426.GB27083@thunk.org> <6C608D9A-AAAC-402D-BC7B-FC23EF9956BD@dilger.ca> <20140114160813.GA11232@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3E18E692-8F00-4727-B84C-0311B85E8775"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42221 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAPUVw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jan 2014 15:21:52 -0500
Received: by mail-pb0-f48.google.com with SMTP id rr13so3124460pbb.35
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jan 2014 12:21:52 -0800 (PST)
In-Reply-To: <20140114160813.GA11232@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3E18E692-8F00-4727-B84C-0311B85E8775
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 14, 2014, at 9:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 14, 2014 at 04:21:52AM -0700, Andreas Dilger wrote:
>> A few comments on this new patch:
>> - I think the name will be confusing to users, especially non-native =
English speakers. Is it "sparse_super" or "super_sparse" they want?
>=20
> Yes, good point.  Maybe sparse_super2?  More generally, I don't think
> we want most users of mke2fs ever needing or wanting to use these
> features.  We can kind of handle this by using "mke2fs -T smr", or
> some such, but this is related to something I've been thinking about
> for a while, which is a way of collapsing the following from dumpe2fs:
>=20
> Filesystem features:      has_journal ext_attr resize_inode dir_index =
filetype needs_recovery extent flex_bg sparse_super large_file huge_file =
uninit_bg dir_nlink extra_isize
>=20
> ... into something like this.
>=20
> Filesystem features:      ext4_default_set needs_recovery

I'm OK with this in theory, but it would make it harder to know what
features are actually enabled, especially if "ext4_default_set" is
changing over time.  Also, while this might be OK for "dumpe2fs"
output, it shouldn't be used for the debugfs "features" command
output, since that would break the ability to determine what features
are actually implemented.

>> - I would suspect that group #1 is not the best place to put the =
backup.
>>  For very large filesystems, there is a conflict with the backup =
group
>>  descriptors in group #0 and #1. It would be better to out the one
>>  backup in group #3 or something.  I don't think this will be a =
problem
>>  for SMR drives, since they will be so large that this will easily =
fit inside
>>  (or close to) the flex_bg layout of the inode table.
>=20
> I'm not sure what what you mean by "conflict with the backup
> descriptors in #0 and #1"?

In 4kB blocksize filesystems with 64-bit group descriptors, there
are 64 group descriptors per block, so for the 32k blocks in group
#0 this means a maximum of 32767 * 64 ~=3D 2M groups =3D 255TB before
the group #0 group descriptors collide with the group #1 superblock
and group #1 descriptor backups.

This problem would be avoided by meta_bg, but that also reverts back
to the undesirable behaviour of spreading small metadata chunks all
over the filesystem.  In some respects, meta_bg would be worse than
the normal sparse_super for SMR, since it writes a few blocks every
64 groups, while sparse_super will write a larger number of blocks
together but less often.

It might make sense to combine meta_bg and flex_bg in this case so
that the superblock and its backups are kept in the same groups as
the bitmaps.  That avoids metadata being spread around the disk.

> One reason why I'm inclined to leave a backup at group #1 is that for
> most file systems, sysadmins are trained to know that there is a
> backup at -b 32768.  If we change it to be something else, it makes it
> a bit harder to find the backup sb, which is a consideration.

I thought that e2fsprogs automatically tries to read all of the
backup superblock and group descriptors if the primary fails, so
as long as it is kept in one of the "known" groups it should be
found automatically?

> Yes, bigalloc does change the offset, but that's actually another
> solution I had been looking at for our use case inside google for big
> SMR drives.
>=20
>=20
>> - To simplify matters, it makes sense that super_sparse supersedes
>>  the sparse_super and meta_bg features. It doesn't make sense
>>  to have both. Should it also require flex_bg?  Without it, it is =
mostly
>>  useless.=20
>=20
> Actually, it doesn't supercede meta_bg.  Meta_bg is about where to put
> the block group descriptors to allow for 64-bit online resize, such
> that the bg descriptor blocks are no longer contiguous.  This is
> separate and distinct from the question of which block group have a
> superblock and the contiguous (aka "old-style") set of block group
> descriptors as backup.
>=20
> I agree that for the use case of keeping the data blocks contiguous,
> it only makes sense to use it with flex_bg; but the file systems
> options are largely orthogonal, and it doesn't actually simplify
> anything from a code complexity standpoint to require them.  How we
> make it easy for users to request a certain set of features is a
> different question, and that's where I think ultimately mke2fs's -T
> option is going to come in really handy.
>=20
> 					- Ted


Cheers, Andreas






--Apple-Mail=_3E18E692-8F00-4727-B84C-0311B85E8775
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUtg/W3Kl2rkXzB/gAQJi6w/9GvyAoMJd0IKSJ+Yrvh1iAgPXc0oednu1
5CEIF12Za6bx2MvKQj76dLg0LvSnFpLln4NMdHZdm6WhiZKfr68bGiag7a3raqpB
N43uSsjtvIwWxDNMg8+KSAL0MNTOlDdmtcQRvp9yGWeNYSfICfm5+NB3Lw7QJE2i
Ss2jwisd8lY2rO0YJ1O92B56uKQUhQsxCLbXiNBSHOpU/MyHWExhbWqSRRx4XzGc
X74HhZI/FYslLzoYS5ZBPVdC/gthRvLj1hsAv1ZDnHiaFEt+/syjjBC5LWfXq1j8
90v9txptFTQSKroWk/3dYHoEWHGGGJvRVwt5meMBAYDw4/r6v3XOCQZkD35SAmtQ
eeg4xC6M1145JFMx8SdNcJLLojiR1C750cT9T80NCIDHCnGrq7v8SgR3QtY6Gcur
Wv+1u7C2zNB50sBshs/N1+fJKnHBOH3fxPtCexHxtWgvtHGb6Nnq107Qqhbvgybm
hSVcC5zFupKeOshpXtgiOb8rUxQYUg+rNV4qYStROKX/Cs3NuK0V9msGm58mOf+P
t6p7jrglAzI20KOdM38sPTKhsE4/c9nacYQ+4wSPGZm3zGdWhi3e9tb+uNfsvD+s
Q6xUiViB47SKz+XvxG1zsFHONIgbyMKoqeavefcCCuQTdbjBgN5Gi38peom+I42p
bmpvd1gThvY=
=TKNB
-----END PGP SIGNATURE-----

--Apple-Mail=_3E18E692-8F00-4727-B84C-0311B85E8775--
