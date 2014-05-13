From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if ext4_mb_init()
 fails
Date: Tue, 13 May 2014 12:25:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405131223410.2070@localhost.localdomain>
References: <1399883039-2978-1-git-send-email-tsyvarev@ispras.ru> <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain> <5371F135.7040409@ispras.ru>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1568388389-1399976726=:2070"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbaEMKZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2014 06:25:41 -0400
In-Reply-To: <5371F135.7040409@ispras.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1568388389-1399976726=:2070
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 13 May 2014, Andrey Tsyvarev wrote:

> Date: Tue, 13 May 2014 14:17:25 +0400
> From: Andrey Tsyvarev <tsyvarev@ispras.ru>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Alexey Khoroshilov <khoroshilov@ispras.ru>
> Subject: Re: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if
>     ext4_mb_init() fails
> 
> 
> 12.05.2014 19:08, Lukáš Czerner пишет:
> > On Mon, 12 May 2014, Andrey Tsyvarev wrote:
> > 
> > > Date: Mon, 12 May 2014 12:23:59 +0400
> > > From: Andrey Tsyvarev<tsyvarev@ispras.ru>
> > > To: Theodore Ts'o<tytso@mit.edu>
> > > Cc: Andrey Tsyvarev<tsyvarev@ispras.ru>,
> > >      Andreas Dilger<adilger.kernel@dilger.ca>,linux-ext4@vger.kernel.org,
> > >      linux-kernel@vger.kernel.org, Alexey
> > > Khoroshilov<khoroshilov@ispras.ru>
> > > Subject: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if
> > > ext4_mb_init()
> > >      fails
> > > 
> > > Caches from 'ext4_groupinfo_caches' may be in use by other mounts, which
> > > have already existed.
> > > So, it is incorrect to destroy them when newly requested mount fails.
> > > 
> > > Found by Linux File System Verification project (linuxtesting.org).
> > Makes sense, thanks! Can you please share the test case which
> > triggered this ? It might be worth including in xfstests.
> 
> Actually it was triggered by xfstests themselves but run with fault
> simulation.
> The method of fault simulation is under development/evaluation now, we expect
> to publish a paper describing it in the near future.
> 
> BUG_ON() in get_groupinfo_cache() was firstly triggered by test generic/003,
> but actually it could be any other test, which uses a scratch device: xftests
> itself requires test device(TEST_DEV) mounted, so a fault simulated while
> mount scratch device causes the problem described.

It sounds interesting. I hope that you'll send the information out
to the fsdevel list when your paper is finished, It looks like it
might be quite useful.

Thanks!
-Lukas

> 
> 
> > Reviewed-by: Lukas Czerner<lczerner@redhat.com>
> > 
> > > Signed-off-by: Andrey Tsyvarev<tsyvarev@ispras.ru>
> > > ---
> > >   fs/ext4/mballoc.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > > index 04a5c75..becea1d 100644
> > > --- a/fs/ext4/mballoc.c
> > > +++ b/fs/ext4/mballoc.c
> > > @@ -2607,7 +2607,7 @@ int ext4_mb_init(struct super_block *sb)
> > >   	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
> > >   	if (sbi->s_locality_groups == NULL) {
> > >   		ret = -ENOMEM;
> > > -		goto out_free_groupinfo_slab;
> > > +		goto out;
> > >   	}
> > >   	for_each_possible_cpu(i) {
> > >   		struct ext4_locality_group *lg;
> > > @@ -2632,8 +2632,6 @@ int ext4_mb_init(struct super_block *sb)
> > >   out_free_locality_groups:
> > >   	free_percpu(sbi->s_locality_groups);
> > >   	sbi->s_locality_groups = NULL;
> > > -out_free_groupinfo_slab:
> > > -	ext4_groupinfo_destroy_slabs();
> > >   out:
> > >   	kfree(sbi->s_mb_offsets);
> > >   	sbi->s_mb_offsets = NULL;
> > > 
> 
> --
> Andrey Tsyvarev
> Linux Verification Center, ISPRAS
> 
> 
--8323328-1568388389-1399976726=:2070--
