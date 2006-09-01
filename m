From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Fri, 01 Sep 2006 09:32:22 -0700
Message-ID: <1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com>
References: <1157125829.30578.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@osdl.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:31371 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030183AbWIAQ3I
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Sep 2006 12:29:08 -0400
To: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-09-01 at 17:12 +0100, Anton Altaparmakov wrote:
> Hi,
> 
> On Fri, 1 Sep 2006, Badari Pulavarty wrote:
> > 
> > I have been running into following bug while running fsx
> > tests on 1k (ext3) filesystem all the time. 
> > 
> > ----------- [cut here ] --------- [please bite here ] ---------
> > Kernel BUG at fs/buffer.c:2791
> > invalid opcode: 0000 [1] SMP
> > 
> > Its complaining about BUG_ON(!buffer_mapped(bh)).
> > 
> > It was hard to track it down, needed lots of debug - but here 
> > is the problem & fix.  Since the fix is in __set_page_buffer_dirty()
> > code - I am wondering how it would effect others :(
> 
> This will breaks NTFS and probably a lot of other file systems I would 
> think.

Well, it can happen only with fileystems with blocksize < pagesize.
So, that should limit the scope :)

> 
> For example all buffer based file systems in their writepage 
> implementations will create buffers if none are present and those will not 
> be mapped.  If for whatever reason writepage now breaks out before mapping 
> the buffers (e.g. because the buffers do not need to be written or due to 
> an error) you are left with a page containing unmapped buffers.
> 
> Then a page dirty comes in caused by a mmapped write for example.
> 
> __set_page_dirty_bufferes() runs by default and with your patch does not 
> set the unmapped buffers dirty thus they never get written out and you 
> have data corruption.

I was wondering, is it *okay* to have a dirty buffer but not mapped to
disk ? I guess, so ..

> 
> It is the caller of submit_bh() that is doing the stupidity of submitting 
> unmapped buffers for i/o or even the caller of the caller, etc...  
> Somewhere up in that chain buffers should have been mapped before being 
> submitted for i/o otherwise it is a BUG() (as correctly identified by 
> submit_bh()).
> 
> Perhaps the real fix is not to have ext3 use ll_rw_block() and instead 
> make it use submit_bh() directly and only submit buffers inside the file 
> size and/or make it map buffers before calling ll_rw_block() and if they 
> are outside the file size just clean them without submitting them...

Yeah. I considered doing it in ll_rw_block() - but then I thought
fixing it in set_page_buffer_dirty() may be a valid fix :(

Let me try other options, then.

Thanks,
Badari



