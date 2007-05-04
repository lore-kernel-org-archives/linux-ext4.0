From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 04 May 2007 10:18:12 +0400
Message-ID: <463AD024.6060208@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>	<20070427013350.d0d7ac38.akpm@linux-foundation.org>	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>	<20070427193130.GD5967@schatzie.adilger.int>	<20070427151837.f1439639.akpm@linux-foundation.org>	<463A1E02.8020506@clusterfs.com> <20070503165428.855eb7d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marat Buharov <marat.buharov@gmail.com>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:64260 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbXEDGSc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 May 2007 02:18:32 -0400
In-Reply-To: <20070503165428.855eb7d7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> Yes, there can be issues with needing to allocate journal space within the
> context of a commit.  But

no-no, this isn't required. we only need to mark pages/blocks within
transaction, otherwise race is possible when we allocate blocks in transaction,
then transacton starts to commit, then we mark pages/blocks to be flushed
before commit.

> a) If the page has newly allocated space on disk then the metadata which
>    refers to that page is already in the journal: no new journal space
>    needed.
> 
> b) If the page doesn't have space allocated on disk then we don't need
>    to write it out at ordered-mode commit time, because the post-recovery
>    filesystem will not have any references to that page.
> 
> c) If the page is dirty due to overwrite then no metadata update was required.
> 
> IOW, under what circumstances would an ordered-mode commit need to allocate
> space for a delayed-allocate page?

no need to allocate space within commit thread, I think. only to take care
of the race I described above. in hackish version of data=ordered for delayed
allocation I used counter of submitted bio's with newly-allocated blocks and
commit thread waits for the counter to reach 0.

> 
> However b) might lead to the hey-my-file-is-full-of-zeroes problem.
> 

thanks, Alex
