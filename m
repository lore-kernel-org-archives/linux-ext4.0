From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 04 May 2007 10:57:12 +0400
Message-ID: <463AD948.9090103@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>	<20070427013350.d0d7ac38.akpm@linux-foundation.org>	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>	<20070427193130.GD5967@schatzie.adilger.int>	<20070427151837.f1439639.akpm@linux-foundation.org>	<463A1E02.8020506@clusterfs.com>	<20070503165428.855eb7d7.akpm@linux-foundation.org>	<463AD024.6060208@clusterfs.com> <20070503233804.9dace4a7.akpm@linux-foundation.org>
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
Received: from mail.chehov.net ([80.71.245.247]:58526 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767694AbXEDG53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 May 2007 02:57:29 -0400
In-Reply-To: <20070503233804.9dace4a7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Fri, 04 May 2007 10:18:12 +0400 Alex Tomas <alex@clusterfs.com> wrote:
> 
>> Andrew Morton wrote:
>>> Yes, there can be issues with needing to allocate journal space within the
>>> context of a commit.  But
>> no-no, this isn't required. we only need to mark pages/blocks within
>> transaction, otherwise race is possible when we allocate blocks in transaction,
>> then transacton starts to commit, then we mark pages/blocks to be flushed
>> before commit.
> 
> I don't understand.  Can you please describe the race in more detail?

if I understood your idea right, then in data=ordered mode, commit thread writes
all dirty mapped blocks before real commit.

say, we have two threads: t1 is a thread doing flushing and t2 is a commit thread

t1					t2
find dirty inode I
find some dirty unallocated blocks
journal_start()
allocate blocks
attach them to I
journal_stop()

					going to commit
					find inode I dirty
					do NOT find these blocks because they're
					  allocated only, but pages/bhs aren't mapped
					  to them
					start commit


map pages/bhs to just allocate blocks


so, either we mark pages/bhs someway within journal_start()--journal_stop() or
commit thread should do lookup for all dirty pages. the latter doesn't sound nice, IMHO.

thanks, Alex
