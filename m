From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ext3 freeze feature
Date: Sat, 16 Feb 2008 08:25:02 -0500
Message-ID: <20080216132502.GB1344@infradead.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp> <20080208132657.GE3120@webber.adilger.int> <20080208145911.GA4257@infradead.org> <79B050214DA541F9A8B193C7AACC3C7B@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbYBPNZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2008 08:25:07 -0500
Content-Disposition: inline
In-Reply-To: <79B050214DA541F9A8B193C7AACC3C7B@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 15, 2008 at 08:51:15PM +0900, Takashi Sato wrote:
> So XFS_IOC_FREEZE and XFS_IOC_THAW cannot be lifted to generic code simply.
> I think we should create new generic numbers for freeze and thaw

Actually we've lifted specific ioctls to the generic layer before all
the time in drivers.  That's the only way to make functionality that was
specific to a single driver (or in this case filesystem) generic.  If
the numbering issues confuses you make sure to add a big comment
describing it

> And xfs_freeze calls XFS_IOC_FREEZE with a magic number 1, but what is 1?

As Eric said it's ignored.

> Instead, I'd like the sec to timeout on freeze API in order to thaw
> the filesystem automatically.  It can prevent a filesystem from staying
> frozen forever.
> (Because a freezer may cause a deadlock by accessing the frozen filesystem.)

Timeout based locking is generally a horrible idea, there's a reason
we don't have any primitives for that in the kernel :)
