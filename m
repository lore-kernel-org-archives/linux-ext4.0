From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/2] E2fsprogs: use the generic inode flags
Date: Mon, 18 Apr 2011 19:15:41 +0800
Message-ID: <4DAC1D5D.3020506@coly.li>
References: <4DA2A0CC.9000301@cn.fujitsu.com> <4DABEA36.5060007@cn.fujitsu.com> <4DABF93E.1030504@coly.li> <4DABFDF0.9060608@cn.fujitsu.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	tytso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36765 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754227Ab1DRKqI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Apr 2011 06:46:08 -0400
In-Reply-To: <4DABFDF0.9060608@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B404=E6=9C=8818=E6=97=A5 17:01, liubo Wrote:
> On 04/18/2011 04:41 PM, Coly Li wrote:
>> On 2011=E5=B9=B404=E6=9C=8818=E6=97=A5 15:37, liubo Wrote:
>>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>>> ---
>>>  debugfs/htree.c        |    2 +-
>>>  e2fsck/pass1.c         |   22 +++++++++++-----------
>>>  e2fsck/pass2.c         |    2 +-
>>>  e2fsck/pass4.c         |    2 +-
>>>  e2fsck/rehash.c        |    4 ++--
>>>  ext2ed/inode_com.c     |   14 +++++++-------
>>>  lib/e2p/fgetflags.c    |    6 +++---
>>>  lib/e2p/fsetflags.c    |    6 +++---
>>>  lib/e2p/getflags.c     |    6 +++---
>>>  lib/e2p/pf.c           |   34 +++++++++++++++++-----------------
>>>  lib/e2p/setflags.c     |    6 +++---
>>>  lib/ext2fs/ext2_fs.h   |   44 ++++++++++++++++++++++--------------=
--------
>>>  lib/ext2fs/link.c      |    4 ++--
>>>  lib/ext2fs/mkjournal.c |    2 +-
>>>  misc/chattr.c          |   26 +++++++++++++-------------
>>>  misc/tune2fs.c         |    2 +-
>>>  16 files changed, 91 insertions(+), 91 deletions(-)
>>> [snip]
>>
>> Hi Bo,
>>
>> Could you please to introduce the motivation of this patch set a lit=
tle bit more? Thanks.
>>
>=20
> Hi Li,
>=20
> Since we want to control COW and compression attribute on a per file =
or per directory basis,
> and find that the generic command "chattr" is the "Mr Right".
>=20
> Currently only btrfs supports both, of course.
>=20
> With these patches, we can do the followings:
>=20
> c: compress
> C: nocow
>=20
> set compress & nocow:
>=20
> # ./misc/chattr -V +c +C /mnt/btrfs/dir/
> chattr 1.41.14 (22-Dec-2010)
> Flags of /mnt/btrfs/dir/ set as --------c------C
>=20
> # ./misc/lsattr -d /mnt/btrfs/dir/
> --------c------C /mnt/btrfs/dir/
>=20

Thank you for the explaining. Now I understand this patch set is to mak=
e chattr of e2fsprogs to support a
(currently-only) btrfs feature.

It seems chattr and lsattr is not an ext[234] only utilities any more..=
=2E

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
