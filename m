From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/2] E2fsprogs: use the generic inode flags
Date: Mon, 18 Apr 2011 16:41:34 +0800
Message-ID: <4DABF93E.1030504@coly.li>
References: <4DA2A0CC.9000301@cn.fujitsu.com> <4DABEA36.5060007@cn.fujitsu.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	tytso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:34441 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753379Ab1DRIME (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Apr 2011 04:12:04 -0400
In-Reply-To: <4DABEA36.5060007@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B404=E6=9C=8818=E6=97=A5 15:37, liubo Wrote:
>=20
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  debugfs/htree.c        |    2 +-
>  e2fsck/pass1.c         |   22 +++++++++++-----------
>  e2fsck/pass2.c         |    2 +-
>  e2fsck/pass4.c         |    2 +-
>  e2fsck/rehash.c        |    4 ++--
>  ext2ed/inode_com.c     |   14 +++++++-------
>  lib/e2p/fgetflags.c    |    6 +++---
>  lib/e2p/fsetflags.c    |    6 +++---
>  lib/e2p/getflags.c     |    6 +++---
>  lib/e2p/pf.c           |   34 +++++++++++++++++-----------------
>  lib/e2p/setflags.c     |    6 +++---
>  lib/ext2fs/ext2_fs.h   |   44 ++++++++++++++++++++++----------------=
------
>  lib/ext2fs/link.c      |    4 ++--
>  lib/ext2fs/mkjournal.c |    2 +-
>  misc/chattr.c          |   26 +++++++++++++-------------
>  misc/tune2fs.c         |    2 +-
>  16 files changed, 91 insertions(+), 91 deletions(-)
> [snip]

Hi Bo,

Could you please to introduce the motivation of this patch set a little=
 bit more? Thanks.

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
