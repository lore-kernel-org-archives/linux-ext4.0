From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] fs: kill i_alloc_sem
Date: Tue, 21 Jun 2011 05:35:21 -0400
Message-ID: <20110621093521.GA32071@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.175620498@bombadil.infradead.org>
 <20110621054056.GP32466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hirofumi@mail.parknet.co.jp, mfasheh@suse.com, jlbec@evilplan.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110621054056.GP32466@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 21, 2011 at 03:40:56PM +1000, Dave Chinner wrote:
> Modification of inode->i_state is not safe outside the
> inode->i_lock.

We never actually set the new bit in i_state, we just use it as a key
for the hashed lookups.  Or rather we try to, as I misunderstood how
wait_on_bit works, so currently we busywait for i_dio_count to reach
zero.  I'll respin a version that actually works as expected.

