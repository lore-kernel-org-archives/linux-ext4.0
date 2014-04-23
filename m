From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 23 Apr 2014 11:30:57 -0400
Message-ID: <20140423153057.GF10985@gradx.cs.jhu.edu>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6gQwMJXxXgY8ZpDE"
Cc: admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:44896 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaDWPbB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2014 11:31:01 -0400
Content-Disposition: inline
In-Reply-To: <20140423143642.GA29925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--6gQwMJXxXgY8ZpDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 10:36:42AM -0400, Theodore Ts'o wrote:
> OK, with the two of you reporting this problem, can you do me the
> following so we can try to seriously dig into this:
>
> First, of all, can you go through your log files and find me as many
> instances of these two pairs of ext4 error messges:
>
> EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys. 1934464544, len 32
> EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, f=
ree 14, pa_free 12
>
> I want to see if there's any pattern in the physical block number (in
> the two samples I have, they are always fairly large numbers), and in
> the difference between the free and pa_free numbers.

The current set of logs on the machine contain only two instance of that pa=
ir,
which may not be useful for extracting information:

kern.log.1:Apr 20 09:11:13 afsscratch-kvm kernel: [817576.492013] EXT4-fs (=
vdd): pa ffff88000dea9b90: logic 0, phys. 1934464544, len 32
kern.log.1:Apr 20 09:11:13 afsscratch-kvm kernel: [817576.492468] EXT4-fs e=
rror (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_=
free 12

kern.log.3.gz:Apr  3 14:01:04 afsscratch-kvm kernel: [309894.428685] EXT4-f=
s (sdd): pa ffff88000d9f9440: logic 832, phys. 957458972, len 192
kern.log.3.gz:Apr  3 14:01:04 afsscratch-kvm kernel: [309894.430023] EXT4-f=
s error (device sdd): ext4_mb_release_inode_pa:3729: group 29219, free 192,=
 pa_free 191

A good many of our errors come from the allocation side, rather than the
release side; I don't know if this is helpful or useless, but here is
everything in the logs from over there:

kern.log.2.gz:Apr  9 02:10:21 afsscratch-kvm kernel: [384951.911190] EXT4-f=
s error (device sdd): ext4_mb_generate_buddy:756: group 51014, 2813 cluster=
s in bitmap, 2811 in gd; block bitmap corrupt.
kern.log.2.gz:Apr  9 13:01:23 afsscratch-kvm kernel: [11422.362996] EXT4-fs=
 error (device sdd): ext4_mb_generate_buddy:756: group 42947, 10106 cluster=
s in bitmap, 10105 in gd; block bitmap corrupt.
kern.log.2.gz:Apr  9 17:31:18 afsscratch-kvm kernel: [   24.426020] EXT4-fs=
 error (device sdb): ext4_mb_generate_buddy:756: group 42947, 11128 cluster=
s in bitmap, 11127 in gd; block bitmap corrupt.
kern.log.2.gz:Apr  9 17:36:07 afsscratch-kvm kernel: [  313.312122] EXT4-fs=
 (sdb): error count: 3
kern.log.2.gz:Apr  9 17:36:07 afsscratch-kvm kernel: [  313.312895] EXT4-fs=
 (sdb): initial error at 1397062883: ext4_mb_generate_buddy:756
kern.log.2.gz:Apr  9 17:36:07 afsscratch-kvm kernel: [  313.314256] EXT4-fs=
 (sdb): last error at 1397079078: ext4_mb_generate_buddy:756
kern.log.2.gz:Apr 12 04:41:30 afsscratch-kvm kernel: [110192.817447] EXT4-f=
s error (device vdd): ext4_mb_generate_buddy:756: group 53425, 84 clusters =
in bitmap, 82 in gd; block bitmap corrupt.
kern.log.3.gz:Apr  3 21:08:51 afsscratch-kvm kernel: [25112.853350] EXT4-fs=
 error (device sdf): ext4_mb_generate_buddy:756: group 29219, 22572 cluster=
s in bitmap, 22571 in gd; block bitmap corrupt.
kern.log.3.gz:Apr  4 07:44:37 afsscratch-kvm kernel: [34909.921245] EXT4-fs=
 error (device sdd): ext4_mb_generate_buddy:756: group 29219, 22572 cluster=
s in bitmap, 22571 in gd; block bitmap corrupt.
kern.log.3.gz:Apr  4 12:29:47 afsscratch-kvm kernel: [  238.509158] EXT4-fs=
 error (device sdd): ext4_mb_generate_buddy:756: group 29219, 22572 cluster=
s in bitmap, 22571 in gd; block bitmap corrupt.
kern.log.4.gz:Mar 25 14:10:04 afsscratch-kvm kernel: [1801025.178704] EXT4-=
fs error (device sdf): ext4_mb_generate_buddy:756: group 50994, 3915 cluste=
rs in bitmap, 3913 in gd; block bitmap corrupt.
kern.log.4.gz:Mar 30 22:52:28 afsscratch kernel: [2264368.806787] EXT4-fs e=
rror (device sdf): ext4_mb_generate_buddy:756: group 52439, 3034 clusters i=
n bitmap, 3032 in gd; block bitmap corrupt.
kern.log.4.gz:Mar 30 23:42:36 afsscratch-kvm kernel: [ 2603.487997] EXT4-fs=
 error (device sdd): ext4_mb_generate_buddy:756: group 52439, 3034 clusters=
 in bitmap , 3032 in gd; block bitmap corrupt.

> Secondly, can you send me the output of dumpe2fs -h for the file
> systems in question.

Filesystem volume name:   <none>
Last mounted on:          /vicepm
Filesystem UUID:          cd47ccd7-92e7-4155-87b2-772828019d52
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filet=
ype n
eeds_recovery extent flex_bg sparse_super large_file huge_file uninit_bg di=
r_nli
nk extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              335544320
Block count:              2684354560
Reserved block count:     134217728
Free blocks:              1386563079
Free inodes:              331912336
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
Filesystem created:       Tue Feb 25 18:06:24 2014
Last mount time:          Sun Apr 20 14:08:10 2014
Last write time:          Sun Apr 20 14:08:10 2014
Mount count:              2
Maximum mount count:      -1
Last checked:             Sun Apr 20 11:22:42 2014
Check interval:           0 (<none>)
Lifetime writes:          4834 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      3c362c29-250b-421a-bdc2-472c611b219d
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x000e5c4b
Journal start:            25891

> Finally, since the both of you are seeing these messages fairly
> frequently, would you be willing to run with a patched kernel?
> Specifically, can you add a WARN_ON(1) to fs/ext4/mballoc.c here:
>
> 	if (free !=3D pa->pa_free) {
> 		ext4_msg(e4b->bd_sb, KERN_CRIT,
> 			 "pa %p: logic %lu, phys. %lu, len %lu",
> 			 pa, (unsigned long) pa->pa_lstart,
> 			 (unsigned long) pa->pa_pstart,
> 			 (unsigned long) pa->pa_len);
> 		ext4_grp_locked_error(sb, group, 0, 0, "free %u, pa_free %u",
> 					free, pa->pa_free);
> 		WARN_ON(1); <---------------- add this line		=09
> 		/*
> 		 * pa is already deleted so we use the value obtained
> 		 * from the bitmap and continue.
> 		 */
> 	}
>
> Then when it triggers, can you send me the stack trace that will be
> triggered by the WARN_ON.

I will not be able to roll that kernel immediately, but I can at some point
(possibly this weekend).

> The two really interesting commonalities which I've seen so far is:
>
> 1)  You are both using virtualization via qemu/kvm
>
> 2)  You are both using file systems > 8TB.
>
> Yes?  And Sander, you're not using a remote block device, correct?
> You're using a local disk to back the large fileystem on the host OS
> side?

Yes.

Cheers,
--nwf;

--6gQwMJXxXgY8ZpDE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNX3LEACgkQTeQabvr9Tc80oQCfZEDi1nZQxMosTU4pPyyB51bW
O2IAn1wClIKY/amjacd5aeSx826m2oP8
=p6k1
-----END PGP SIGNATURE-----

--6gQwMJXxXgY8ZpDE--
