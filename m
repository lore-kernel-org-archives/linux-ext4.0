From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] fix up lazy_bg bitmap initialization at mkfs time
Date: Fri, 20 Apr 2007 04:10:20 -0600
Message-ID: <20070420101020.GQ5967@schatzie.adilger.int>
References: <4627DA21.7050002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48849 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXDTKKW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 06:10:22 -0400
Content-Disposition: inline
In-Reply-To: <4627DA21.7050002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 19, 2007  16:07 -0500, Eric Sandeen wrote:
> While trying out the -O lazy_bg option, I ran into some trouble on my
> big filesystem.  The journal size was > free blocks in the first block group,
> so it spilled into the next bg with available blocks.  Since we are using
> lazy_bg here, that -should- have been the last block group.

Just as an FYI - it probably makes little sense to have a 128MB journal
for a filesystem you want to use for testing, since it would still write
128MB to your loopback device when zeroing the journal.  It still makes
sense for mke2fs and libext2fs to be fixed for correctness, but I think
it also makes sense for lazy_bg to influence the journal size.

> Unfortunately it also increases mkfs time a bit, as it must search
> a huge string of unavailable blocks if it has to allocate in the 
> last bg.  Ah well...

It also probably makes sense for libext2fs to check group descriptors
while allocating...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
