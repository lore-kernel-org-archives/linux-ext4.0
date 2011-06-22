From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Wed, 22 Jun 2011 20:13:42 +0200
Message-ID: <20110622181342.GC26160@quack.suse.cz>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110621235425.GA24067@quack.suse.cz>
 <20110622142235.GN32133@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110622142235.GN32133@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 22-06-11 10:22:35, Ted Tso wrote:
> On Wed, Jun 22, 2011 at 01:54:25AM +0200, Jan Kara wrote:
> > ext4_page_mkwrite()... Ted, what happened to that patch. Should I resend
> > it?
> 
> So assuming I fix the refcounting issue in fs/ext4/page_io.c (which I
> will do not dropping the page's refcount until after the workqueue
> finishes its job), does your patch need changing, or is it a matter of
> fixing the commit description?
  Looking into patchwork (http://patchwork.ozlabs.org/patch/97924/) I see
the discussion of two issues (page refcounting and page_mkwrite got mixed).
I see the patch just needs fixing commit description because it's no longer
accurate after "stable page under writeback" changes went it. I'll send you
a patch with updated changelog in a minute.

> In any case, this dragged got out, and it's late in -rc cycle for 3.0,
> so I was planning on queuing this for the next merge window.  (Sorry
> for that, this was mostly due to my not having enough time to really
> dive into the issues involved.)
  No problem. Just we have to somehow coordinate with Christoph... Either
he can avoid touching ext4 and merge his patch set after you merge my patch
or he can take my patch instead of his ext4 change. Since my patch touches
only ext4_page_mkwrite() there's not a high risk of collision. The latter
would seem easier for both of you to me but I don't really care.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
