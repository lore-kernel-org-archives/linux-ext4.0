From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] E2fsprogs: use the generic inode flags
Date: Mon, 18 Apr 2011 17:01:36 +0800
Message-ID: <4DABFDF0.9060608@cn.fujitsu.com>
References: <4DA2A0CC.9000301@cn.fujitsu.com> <4DABEA36.5060007@cn.fujitsu.com> <4DABF93E.1030504@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	tytso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50806 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab1DRI75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Apr 2011 04:59:57 -0400
In-Reply-To: <4DABF93E.1030504@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/18/2011 04:41 PM, Coly Li wrote:
> On 2011=E5=B9=B404=E6=9C=8818=E6=97=A5 15:37, liubo Wrote:
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  debugfs/htree.c        |    2 +-
>>  e2fsck/pass1.c         |   22 +++++++++++-----------
>>  e2fsck/pass2.c         |    2 +-
>>  e2fsck/pass4.c         |    2 +-
>>  e2fsck/rehash.c        |    4 ++--
>>  ext2ed/inode_com.c     |   14 +++++++-------
>>  lib/e2p/fgetflags.c    |    6 +++---
>>  lib/e2p/fsetflags.c    |    6 +++---
>>  lib/e2p/getflags.c     |    6 +++---
>>  lib/e2p/pf.c           |   34 +++++++++++++++++-----------------
>>  lib/e2p/setflags.c     |    6 +++---
>>  lib/ext2fs/ext2_fs.h   |   44 ++++++++++++++++++++++---------------=
-------
>>  lib/ext2fs/link.c      |    4 ++--
>>  lib/ext2fs/mkjournal.c |    2 +-
>>  misc/chattr.c          |   26 +++++++++++++-------------
>>  misc/tune2fs.c         |    2 +-
>>  16 files changed, 91 insertions(+), 91 deletions(-)
>> [snip]
>=20
> Hi Bo,
>=20
> Could you please to introduce the motivation of this patch set a litt=
le bit more? Thanks.
>=20

Hi Li,

Since we want to control COW and compression attribute on a per file or=
 per directory basis,
and find that the generic command "chattr" is the "Mr Right".

Currently only btrfs supports both, of course.

With these patches, we can do the followings:

c: compress
C: nocow

set compress & nocow:

# ./misc/chattr -V +c +C /mnt/btrfs/dir/
chattr 1.41.14 (22-Dec-2010)
=46lags of /mnt/btrfs/dir/ set as --------c------C

# ./misc/lsattr -d /mnt/btrfs/dir/
--------c------C /mnt/btrfs/dir/

thanks,
liubo
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
