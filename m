From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] far: remove i_alloc_sem abuse
Date: Tue, 21 Jun 2011 12:09:42 -0400
Message-ID: <20110621160942.GA878@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202030.577464178@bombadil.infradead.org>
 <87fwn3mb2g.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fwn3mb2g.fsf@devron.myhome.or.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 22, 2011 at 12:57:43AM +0900, OGAWA Hirofumi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Add a new rw_semaphore to protect bmap against truncate.  Previous
> > i_alloc_sem was abused for this, but it's going away in this series.
> 
> In FAT case, ->i_mutex was better. But, last time I saw, shmfs was using
> ->i_mutex to call ->bmap. So, this was chosen instead.
> 
> I'm not checking current version yet though, if shmfs had change, we can
> use ->i_mutex.

I tried that first, but it gives an instant deadlock when using a
swapfile on fat.

