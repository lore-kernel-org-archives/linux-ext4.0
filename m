From: Contact <neitsab@ovh.fr>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc, e4defrag...)
Date: Sun, 20 Apr 2014 21:38:30 +0200
Message-ID: <53542236.9030201@ovh.fr>
References: <534F39F6.2000208@ovh.fr> <20140417152457.GE18591@thunk.org> <5350205E.3030403@ovh.fr> <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain> <5353DBC2.5080708@ovh.fr> <20140420190146.GB29727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo29.mail-out.ovh.net ([178.32.228.29]:52756 "EHLO
	mo29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaDTTic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2014 15:38:32 -0400
In-Reply-To: <20140420190146.GB29727@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le dim. 20 avril 2014 21:01:46 CEST, Theodore Ts'o a =C3=A9crit :
>
> This requires recompiling e2fsprogs using the tip of the maint branch=
,
> as I had suggested earlier (and which you had ruled out because you
> didn't want to build your own e2fsprogs from source).
>
Thanks, that explains why I wasn't able to find this option in regular=20
e2fsprogs.

> Once you do this, and you put the following in
>
> 	hugefiles =3D {
> 		features =3D extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isi=
ze,^resize_inode,sparse_super2
> 		hash_alg =3D half_md4
> 		num_backup_sb =3D 0
> 		packed_meta_blocks =3D 1
> 		flex_bg_size =3D 262144
> 		inode_ratio =3D 4194304
> 		make_hugefiles =3D 1
> 		hugefiles_dir =3D /boot
> 		hugefiles_name =3D contig-files
> 		hugefiles_digits =3D 1
> 		hugefiles_size =3D 256M
> 		num_hugefiles =3D 3
> 	}
>
> Using the sparse_super2 feature and setting num_backup_sb=3D0 disable=
s
> the backup superblocks.  Then setting flex_bg_size to a very large
> value (262144 in this case), will force all of the allocation bitmaps
> and inodetables to the very beginning of the file system.
>
The tip and stanza look very useful though, I'll reconsider retrieving=20
and compiling maint branch to try, thanks.

> Note that because this uses a new compat feature, "sparse_super2", if
> you use the new mke2fs to create such a file system, you will also
> need to make sure the file system is checked using a version of e2fsc=
k
> that supports this new feature as well.  No kernel changes are
> required to support this, though.
>
Any plans to get this feature into master at some point in the=20
development?

--Bastien

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
