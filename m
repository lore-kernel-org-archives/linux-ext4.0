From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 19:19:47 +0800
Message-ID: <20131119111947.GA4782@gmail.com>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
 <20131119110147.GA3323@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119110147.GA3323@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 19, 2013 at 03:01:47AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 06:45:08PM +0800, Zheng Liu wrote:
> > BTW, that would be great if you could give me some comments about this
> > problem itself.  Is it a generic problem in vfs?  Or just a feature by
> > design?
> 
> It seems like a fundamental issue with ext4 (and most older Linux
> filesystems) trying to do dio reads without locking out writers.

Ah, that is a long story for me.  Anyway, thanks for your comment.

> 
> If you have a shared/exclusive lock to protect dio reads against
> buffered or appending writers like XFS does this issue is properly
> prevented.

Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
it can pass the test.  But another question is why xfs fails when we do
some append dio writes with doing buffered read.

Regards,
                                                - Zheng
