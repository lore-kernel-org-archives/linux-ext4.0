From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_page_mkwrite and delalloc
Date: Mon, 16 Jun 2008 19:34:34 +0200
Message-ID: <20080616173434.GE3279@atrey.karlin.mff.cuni.cz>
References: <20080612181407.GE22481@skywalker> <20080616141141.GB31567@duck.suse.cz> <20080616160906.GB14214@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60890 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYFPRef (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 13:34:35 -0400
Content-Disposition: inline
In-Reply-To: <20080616160906.GB14214@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Jun 16, 2008 at 04:11:41PM +0200, Jan Kara wrote:
> >   Hi Aneesh,
> > 
> > On Thu 12-06-08 23:44:07, Aneesh Kumar K.V wrote:
> > > With delalloc we should not do writepage in ext4_page_mkwrite. The idea
> > > with delalloc is to delay the block allocation and make sure we allocate
> > > chunks of blocks together at writepages. So i guess we should update
> > > ext4_page_mkwrite to use write_begin and write_end instead of writepage.
> > > Taking i_alloc_sem should protect against parallel truncate and the page
> > > lock should protect against parallel write_begin/write_end.
> > > 
> > > How about the patch below ?
> >   In principle the patch looks fine, I would only like to see two things
> > checked:
> >   1) Did you do some stress testing of the patch - combining mmapped writes
> > with ordinary writes to the same file and truncation so that we detect
> > possible bugs in locking / data corruption due to some bad locking. This
> > significantly changes when write_begin / write_end can be called in ext4
> > (i.e., it is now called without i_mutex - BTW: that is probably worth a
> > comment before these functions).
> >   2) How does this change influence CPU load for mmapped accesses - I worry
> > about write_begin / write_end path being significantly heavier than just
> > calling writepage. Probably just mmap a large file, write single byte
> > to every page and measure using oprofile whether accumulated time spent in
> > page_mkwrite didn't change to much.
> > 
> 
> We can actually get away with page_mkwrite if we agree that SIGBUS on
> ENOSPC is not the right way. We can implement writepages for different
> data mode, and allocate blocks in writepages. With those changes we don't
> allocate blocks for mmap area maping holes upon write. Instead we
> allocate block during writepages. Since we can start a transaction
> during writepages we should be ok with respect to new locking.?
  Yes, but this has the disadvantage that with this solution you are
unable to free memory by writeback under memory pressure in some cases
(at that path we are not called via writepages()). It may or may not
matter, I'm not sure.
  I personally prefer returning SIGBUS on ENOSPC for ext4 (for ext2/ext3
I tend to agree with Andrew that we probably shouldn't change the
behavior).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
