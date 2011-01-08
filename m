From: Tejun Heo <tj@kernel.org>
Subject: Re: Patch to issue pure flushes directly (Was: Re: [PATCH v6 0/4]
 ext4: Coordinate data-only flush requests sent) by fsync
Date: Sat, 8 Jan 2011 09:08:01 -0500
Message-ID: <20110108140801.GB13269@mtj.dyndns.org>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
 <20101130164124.GA30858@lst.de>
 <20110107235449.GT21922@thunk.org>
 <20110108074524.GA13024@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Josef Bacik <josef@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110108074524.GA13024@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Sat, Jan 08, 2011 at 08:45:24AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 07, 2011 at 06:54:49PM -0500, Ted Ts'o wrote:
> > This patch seemed like a good idea to me; I just checked linux-next,
> > and looks like nothing like this is planned to be merged.  Just
> > thought I would send a prod-o-gram to see what the current thinking
> > was around adding something like this.
> 
> I haven't really gotten any feedback on the patch, so it fell on the
> floor for a while.  I've managed to get some big system resources to
> test the impact of it, and once I've got numbers I'll resend it as
> separate patches for scsi and the block layer.

But would it actually make any difference?  It's not like the usual
completion path in the optimized case is much longer.  It will set all
the skip bits, try to determine the next step which is completion and
then complete the flush request.  It'll sure occupy the CPU for a
little bit longer but I don't think it will be anything measureable.
Is there a workload that this can actually help?

Thanks.

-- 
tejun
