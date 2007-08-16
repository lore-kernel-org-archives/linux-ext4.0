From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Thu, 16 Aug 2007 11:46:05 -0700
Message-ID: <20070816114605.5a233c7e.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<20070427013350.d0d7ac38.akpm@linux-foundation.org>
	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	<20070427193130.GD5967@schatzie.adilger.int>
	<20070427151837.f1439639.akpm@linux-foundation.org>
	<463A1E02.8020506@clusterfs.com>
	<20070503165428.855eb7d7.akpm@linux-foundation.org>
	<463AD024.6060208@clusterfs.com>
	<20070503233804.9dace4a7.akpm@linux-foundation.org>
	<463AD948.9090103@clusterfs.com>
	<20070504001802.0e86e9dd.akpm@linux-foundation.org>
	<463AE32A.5000902@clusterfs.com>
	<20070504010212.ce6eca53.akpm@linux-foundation.org>
	<46C49556.4000409@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165AbXHPSqO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2007 14:46:14 -0400
In-Reply-To: <46C49556.4000409@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 16 Aug 2007 22:20:06 +0400
Alex Tomas <alex@clusterfs.com> wrote:

> Andrew Morton wrote:
> >>> But under this proposal, t_sync_datalist just gets removed: the new
> >>> ordered-data mode _only_ need to do the sb->inode->page walk.  So if I'm
> >>> understanding you, the way in which we'd handle any such race is to make
> >>> kjournald's writeback of the dirty pages block in lock_page().  Once it
> >>> gets the page lock it can look to see if some other thread has mapped the
> >>> page to disk.
> >> if I'm right holding number of pages locked, then they won't be locked, but
> >> writeback. of course kjournald can block on writeback as well, but how does
> >> it find pages with *newly allocated* blocks only?
> > 
> > I don't think we'd want kjournald to do that.  Even if a page was dirtied
> > by an overwrite, we'd want to write it back during commit, just from a
> > quality-of-implementation point of view.  If we were to leave these pages
> > unwritten during commit then a post-recovery file could have a mix of
> > up-to-five-second-old data and up-to-30-seconds-old data.
> 
> trying to implement this I've got to think that there is one significant
> difference between t_sync_datalist and sb->inode->page walk: t_sync_datalist
> is per-transaction. IOW, it doesn't change once transaction is closed. in
> contrast, nothing (currently) would prevent others to modify pages while
> commit is in progress.

That can happen at present - there's nothing to stop a process from modifying
a page which is undergoing ordered-data commit-time writeout.
