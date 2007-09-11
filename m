From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] FLEX_BG Kernel support.
Date: Tue, 11 Sep 2007 17:21:39 -0600
Message-ID: <20070911232139.GY5377@schatzie.adilger.int>
References: <20070910212224.13310.54532.stgit@toolssf2> <2aa04ba80709102304i1b054fbbo1d0d4081a86c1580@mail.gmail.com> <20070911072717.1b5fc7a8@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:37501 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbXIKXVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 19:21:14 -0400
Content-Disposition: inline
In-Reply-To: <20070911072717.1b5fc7a8@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 11, 2007  07:27 -0500, Jose R. Santos wrote:
> On Tue, 11 Sep 2007 00:04:43 -0600
> "Andreas Dilger" <adilger@clusterfs.com> wrote:
> > On 9/10/07, Jose R. Santos <jrs@us.ibm.com> wrote:
> > > @@ -1254,7 +1254,8 @@ static int ext4_check_descriptors (struct super_block * sb)
> > >
> > >         for (i = 0; i < sbi->s_groups_count; i++)
> > >         {
> > > -               if (i == sbi->s_groups_count - 1)
> > > +               if (i == sbi->s_groups_count - 1 || EXT4_HAS_INCOMPAT_FEATURE(sb,
> > > +                                       EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > >                         last_block = ext4_blocks_count(sbi->s_es) - 1;
> > 
> > No need to check this featyre for every  group, once at the beginning
> > of the function is enough.
> > 
> 
> Do you mean something like the original patch?
> http://lists.openwall.net/linux-ext4/2007/07/12/20
> 
> Wouldn't we need to check all the descriptor for corruption if checksum
> is not enable on the filesystem?

Yes, I just meant you don't need to have:

	EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))

for each time through the loop.  That loop is walked 8000 times per TB
at mount, so if we can make it faster we should do so.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
