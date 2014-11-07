From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 0/6] ext4: extents status tree shrinker improvement
Date: Fri, 7 Nov 2014 10:38:40 +0800
Message-ID: <20141107023840.GA5420@gmail.com>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <20141020144849.GB4499@thunk.org>
 <20141021102228.GC2955@quack.suse.cz>
 <007DCBDA-B924-4B45-887C-5FFFB8749966@alibaba-inc.com>
 <20141103161046.GA17319@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@alibaba-inc.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	=?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49364 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGC1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2014 21:27:35 -0500
Received: by mail-pa0-f50.google.com with SMTP id eu11so2498697pac.23
        for <linux-ext4@vger.kernel.org>; Thu, 06 Nov 2014 18:27:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20141103161046.GA17319@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2014 at 05:10:46PM +0100, Jan Kara wrote:
>   Hello,
>=20
> On Tue 21-10-14 23:58:10, =E5=88=98=E5=B3=A5(=E6=96=87=E5=8D=BF) wrot=
e:
> > I deeply sorry for this because of my delay work.  I don=E2=80=99t =
have any objection
> > for Jan=E2=80=99s suggestions.  Until now there are still some work=
s that push me
> > tough, and I can see that I don=E2=80=99t have time to finish it at=
 this merge
> > window.  It=E2=80=99s a shame for me!
> >=20
> > Jan, I really really appreciate if you are willing to push this pat=
ch set
> > to completion.  Thanks!!!
>   OK, I have updated the patches according to the review I and Ted di=
d. It
> survives basic fsstress run. How were you testing your patches? I sho=
uld
> probably also gather some statistics etc...

Thanks!!

Here are my test cases for performance.

case 1:
  [global]
  ioengine=3Dpsync
  bs=3D4k
  directory=3D/mnt/sda1
  thread
  group_reporting
  fallocate=3D0
  direct=3D0
  filesize=3D10g
  size=3D20g
  runtime=3D300
 =20
  [io]
  rw=3Drandwrite:32
  rw_sequencer=3Dsequential
  numjobs=3D25
  nrfiles=3D10

case 2:
  [global]
  ioengine=3Dpsync
  bs=3D4k
  directory=3D/mnt/sda1
  group_reporting
  fallocate=3D0
  direct=3D0
  filesize=3D10g
  size=3D20g
  runtime=3D300
 =20
  [io]
  rw=3Dwrite:4k
  numjobs=3D15
  nrfiles=3D20000

=46or getting a really fragmented extent status tree, I will disable
extent status tree merge as I run these test cases.  The patch looks
like below:

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 09fd576..0946f50 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -351,6 +351,7 @@ static void ext4_es_free_extent(struct inode *inode=
, struct extent_status *es)
 static int ext4_es_can_be_merged(struct extent_status *es1,
 				 struct extent_status *es2)
 {
+#if 0
 	if (ext4_es_status(es1) !=3D ext4_es_status(es2))
 		return 0;
=20
@@ -376,6 +377,7 @@ static int ext4_es_can_be_merged(struct extent_stat=
us *es1,
 	/* we need to check delayed extent is without unwritten status */
 	if (ext4_es_is_delayed(es1) && !ext4_es_is_unwritten(es1))
 		return 1;
+#endif
=20
 	return 0;
 }


In the mean time, the following sysctl parameters are adjusted to keep
dirty data in memory as much as possible.

sudo sysctl vm.dirty_ratio=3D80
sudo sysctl vm.dirty_background_ratio=3D60

Thanks,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
