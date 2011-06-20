From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 4/8] fs: kill i_alloc_sem
Date: Mon, 20 Jun 2011 14:32:03 -0700
Message-ID: <20110620213203.GB26204@noexit.corp.google.com>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.175620498@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110620202031.175620498@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 20, 2011 at 04:15:37PM -0400, Christoph Hellwig wrote:
> i_alloc_sem is a rather special rw_semaphore.  It's the last one that may
> be released by a non-owner, and it's write side is always mirrored by
> real exclusion.  It's intended use it to wait for all pending direct I/O
> requests to finish before starting a truncate.
> 
> Replace it with a hand-grown construct:
> 
>  - exclusion for truncates is already guaranteed by i_mutex, so it can
>    simply fall way
>  - the reader side is replaced by an i_dio_count member in struct inode
>    that counts the number of pending direct I/O requests.  Truncate can't
>    proceed as long as it's non-zero
>  - when i_dio_count reaches non-zero we wake up a pending truncate using
>    wake_up_bit on a new bit in i_flags
>  - new references to i_dio_count can't appear while we are waiting for
>    it to read zero because the direct I/O count always needs i_mutex
>    (or an equivalent like XFS's i_iolock) for starting a new operation.
> 
> This scheme is much simpler, and saves the space of a spinlock_t and a
> struct list_head in struct inode (typically 160 bytes on a non-debug 64-bit
> system).

	Are we guaranteed that all allocation changes are locked out by
i_dio_count>0?  I don't think we are.  The ocfs2 code very strongly
assumes the state of a file's allocation when it holds i_alloc_sem.  I
feel like we lose that here. 

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

			http://www.jlbec.org/
			jlbec@evilplan.org
