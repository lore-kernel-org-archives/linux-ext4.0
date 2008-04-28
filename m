From: Jan Kara <jack@suse.cz>
Subject: Re: Possible race between direct IO and JBD?
Date: Mon, 28 Apr 2008 14:26:26 +0200
Message-ID: <20080428122626.GC17054@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz> <1209166706.6040.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, pbadari@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39282 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763297AbYD1M02 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 08:26:28 -0400
Content-Disposition: inline
In-Reply-To: <1209166706.6040.20.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 25-04-08 16:38:23, Mingming Cao wrote:
> While looking at a bug related to direct IO returns to EIO, after
> looking at the code, I found there is a window that
> try_to_free_buffers() from direct IO could race with JBD, which holds
> the reference to the data buffers before journal_commit_transaction()
> ensures the data buffers has reached to the disk.
> 
> A little more detail: to prepare for direct IO, generic_file_direct_IO()
> calls invalidate_inode_pages2_range() to invalidate the pages in the
> cache before performaning direct IO.  invalidate_inode_pages2_range()
> tries to free the buffers via try_to free_buffers(), but sometimes it
> can't, due to the buffers is possible still on some transaction's
> t_sync_datalist or t_locked_list waiting for
> journal_commit_transaction() to process it. 
> 
> Currently Direct IO simply returns EIO if try_to_free_buffers() finds
> the buffer is busy, as it has no clue that JBD is referencing it.
> 
> Is this a known issue and expected behavior? Any thoughts?
  Are you seeing this in data=ordered mode? As Andrew pointed out we do
filemap_write_and_wait() so all the relevant data buffers of the inode
should be already on disk. In __journal_try_to_free_buffer() we check
whether the buffer is already-written-out data buffer and unfile and free
it in that case. It shouldn't happen that a data buffer has
b_next_transaction set so really the only idea why try_to_free_buffers()
could fail is that somebody manages to write to a page via mmap before
invalidate_inode_pages2_range() gets to it. Under which kind of load do you
observe the problem? Do you know exactly because of which condition does
journal_try_to_free_buffers() fail?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
