From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 0/10] freeze feature ver 1.13
Date: Fri, 26 Sep 2008 06:48:16 -0400
Message-ID: <30536.1222426096@turing-police.cc.vt.edu>
References: <20080926175652t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222426096_7097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38536 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIZKtc (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 06:49:32 -0400
In-Reply-To: Your message of "Fri, 26 Sep 2008 17:56:52 +0900."
             <20080926175652t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1222426096_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 17:56:52 +0900, Takashi Sato said:

> [PATCH 1/10] VFS: Fix error handling of write_super_lockfs/unlockfs
>   Changed the type of write_super_lockfs and unlockfs from "void"
>   to "int" so that they can return an error. 
>   Rename write_super_lockfs/unlockfs of the super block operation
>   freeze_fs/unfreeze_fs to avoid a confusion.
> 
> [PATCH 2/10]-[PATCH 6/10] Fix error handling in write_super_lockfs/unlockfs
>                           (ext3, ext4, xfs, gfs2, jfs)
>   Changed write_super_lockfs so that it returns an error if needed.
>   unlockfs always returns 0.
> 
> [PATCH 7/10] reiserfs: Fix error handling in write_super_lockfs/unlockfs
>   Changed write_super_lockfs/unlockfs so that they always return
>   0 (success) to keep a current behavior.
> 
> [PATCH 8/10] Implement generic freeze feature
>   The ioctls for the generic freeze feature are below.
>   o Freeze the filesystem
>     int ioctl(int fd, int FIFREEZE, arg)
>       fd: The file descriptor of the mountpoint
>       FIFREEZE: request code for the freeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
>   o Unfreeze the filesystem
>     int ioctl(int fd, int FITHAW, arg)
>       fd: The file descriptor of the mountpoint
>       FITHAW: request code for unfreeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
> [PATCH 9/10] Remove XFS specific ioctl interfaces for freeze feature
>   It removes XFS specific ioctl interfaces and request codes
>   for freeze feature.
>   This patch has been supplied by David Chinner.
> 
> [PATCH 10/10] Add timeout feature
>   The timeout feature is added to "freeze ioctl" to solve a deadlock
>   when the freezer accesses a frozen filesystem. And new ioctl
>   to reset the timeout period is added to extend the timeout period.
>   For example, the freezer resets the timeout period to 10 seconds every 5
>   seconds.  In this approach, even if the freezer causes a deadlock by
>   accessing the frozen filesystem, it will be solved by the timeout

Would it be a good idea to merge patch 10 into patch 8?   Otherwise, there's
two issues I can see:

1) A mostly theoretical problem if a bisect lands exactly on patch 9 it can
hit the deadlock.

2) The API at patch 8 and patch 10 differs, that's going to make testing through
a bisection of this patch series a pain.

--==_Exmh_1222426096_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3L3wcC3lWbTT17ARAjrhAKC8UZHTiIM5FLH1rhQ70o1u4X66CQCfeopP
jGYlmgzaSwfvHkgcswECSio=
=HZAd
-----END PGP SIGNATURE-----

--==_Exmh_1222426096_7097P--
