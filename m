From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock
 in non-movable area
Date: Thu, 14 Aug 2014 14:23:00 +0900
Message-ID: <53EC47B4.8020408@lge.com>
References: <53EC4531.1000904@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
	=?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53EC4531.1000904@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-08-14 =BF=C0=C8=C4 2:12, Gioh Kim =BE=B4 =B1=DB:
> Hello,
>=20
> This patch try to solve problem that a long-lasting page caches of
> ext4 superblock and journaling of superblock disturb page migration.
>=20
> I've been testing CMA feature on my ARM-based platform
> and found that two page caches cannot be migrated.
> They are page caches of superblock of ext4 filesystem and its journal=
ing data.
>=20
> Current ext4 reads superblock with sb_bread() that allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrat=
ed forever.
> And also the journaling data for the superblock cannot be migreated.
>=20
> I introduce a new API for allocating page cache from non-movable area=
=2E
> It is useful for ext4/ext3 and others that want to hold page cache fo=
r a long time.
>=20
> I have 3 patchs:
>=20
> 1. Patch 1/3: introduce a new API that create page cache from non-mov=
able area
> 2. Patch 2/3: have ext4 use the new API to read superblock
> 3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of sup=
erblock
>=20
> This patchset is based on linux-next-20140814.
>=20
> Thanks a lot.
>=20
> Gioh Kim (3):
>   fs/buffer.c: allocate buffer cache from non-movable area
>   ext4: allocate buffer-cache for superblock in non-movable area
>   jbd-jbd2-allocate-buffer-cache-for-superblock-inode-.patch
>=20
>   fs/buffer.c                 |   63 ++++++++++++++++++++++++++++++--=
--
>   fs/ext4/super.c             |    6 +--
>   fs/jbd/journal.c            |    2 -
>   fs/jbd2/journal.c           |    2 -
>   include/linux/buffer_head.h |   10 +++++
>   5 files changed, 71 insertions(+), 12 deletions(-)
>=20

I'm sorry to forget mentioning that this is 2nd version of https://lkml=
=2Eorg/lkml/2014/7/22/34.
