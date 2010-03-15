From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [00/11] fix ext4 deadlock on 2.6.27.y
Date: Mon, 15 Mar 2010 13:09:30 -0700
Message-ID: <20100315200929.GA20466__33127.3228432567$1268687188$gmane$org@kroah.com>
References: <4B88BA1B.4050500@jaysonking.com>
 <20100228031635.GC1278@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Jayson R. King" <dev@jaysonking.com>,
	Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936722Ab0COVFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 17:05:52 -0400
Content-Disposition: inline
In-Reply-To: <20100228031635.GC1278@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 27, 2010 at 07:16:35PM -0800, Greg KH wrote:
> On Sat, Feb 27, 2010 at 12:22:19AM -0600, Jayson R. King wrote:
> > Greetings,
> > 
> > Using the kernel 2.6.27.45 with an ext4 filesystem, the same deadlock as
> > was reported earlier in kernel bugzilla #12579 can occur. Simply running
> > "dbench 500" on an ext4 filesystem can cause the deadlock in one to two
> > minutes.
> > 
> > In later stable kernels, the deadlock was fixed by commit 2acf2c26
> > ("ext4: Implement range_cyclic in ext4_da_writepages instead of
> > write_cache_pages"). I can confirm that the same commit fixes the
> > deadlock on 2.6.27.y. However, as the code in ext4_da_writepages is
> > different in 2.6.27.y than in later kernels, it was necessary to add
> > some other mainline patches before 2acf2c26.
> > 
> > Alltogether, I've added 11 mainline patches including 2acf2c26 to my
> > local 2.6.27.y kernel, and confirmed that the deadlock is fixed only
> > when the patch 2acf2c26 is applied.
> > 
> > The 11 patches are:
> > 
> > Aneesh Kumar K.V (10):
> >       ext4: invalidate pages if delalloc block allocation fails.
> >       ext4: Make sure all the block allocation paths reserve blocks
> >       ext4: Add percpu dirty block accounting.
> >       ext4: Retry block reservation
> >       ext4: Retry block allocation if we have free blocks left
> >       ext4: Use tag dirty lookup during mpage_da_submit_io
> >       vfs: Remove the range_cont writeback mode.
> >       vfs: Add no_nrwrite_index_update writeback control flag
> >       ext4: Fix file fragmentation during large file write.
> >       ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages
> > 
> > Mingming Cao (1):
> >       percpu counter: clean up percpu_counter_sum_and_set()
> > 
> > All will be posted in a reply to this message, in the order that they apply.
> > 
> > I think these patches should be committed to stable 2.6.27.y.
> 
> What do the ext4 maintainers think about this?  If they ack this, I'll
> be glad to queue them up in the next release.

As no one has responded, I'm dropping these from my email queue.  If you
get an answer, please feel free to resend them.

thanks,

greg k-h
