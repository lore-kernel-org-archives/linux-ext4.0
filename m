From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: Re: Maximum number of directories
Date: Mon, 04 Feb 2013 13:36:29 +0000
Message-ID: <3667261.Q2Z9h3nZ4l@deuteros>
References: <17001225.1MS6YREEfJ@deuteros> <CAD6i1fKHDP3m8EQZVaY-3VQ+6kh5=Bv7SQhLozJJEb7UJ5q=VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:45717 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab3BDNgf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2013 08:36:35 -0500
In-Reply-To: <CAD6i1fKHDP3m8EQZVaY-3VQ+6kh5=Bv7SQhLozJJEb7UJ5q=VQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 04 February 2013 18:49:54 Prashant Shah wrote:
> Hi,
> 
> On Mon, Feb 4, 2013 at 4:25 PM, Tvrtko Ursulin
> 
> <tvrtko.ursulin@onelan.co.uk> wrote:
> > I was creating such a (crazy?) tree and hit -ENOSPC at ~31 million
> > directories created in total with df showing only 40% use:
> > 
> > Inode count:              29868032
> > Free inodes:              29848131
> 
> Since, each directory will use a inode entry, there is some mismatch
> with ~31 million directories and 19901 inodes in use. The inode usage
> count should be much larger. You have max 29 million inodes available
> - so max can be 29 million directories.

Yeah, I totally forgot about the inode situation on ext filesystems. So is 
tune2fs giving wrong stats for live (mounted) filesystems?

> Try $blk

What is that?

Thanks,

Tvrtko

