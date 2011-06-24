From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] fs: kill i_alloc_sem
Date: Fri, 24 Jun 2011 14:34:31 -0400
Message-ID: <20110624183431.GA7345@infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
 <20110624183207.548752715@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110624183207.548752715@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> This scheme is much simpler, and saves the space of a spinlock_t and a
> struct list_head in struct inode (typically 160 bytes on a non-debug 64-bit
> system).

And I still haven't fixed that typo, damn.  Updated in local version now
to make sure it won't be missed next time.

