From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Possible race between direct IO and JBD?
Date: Sat, 26 Apr 2008 03:41:39 -0700
Message-ID: <20080426034139.0dafc76e.akpm@linux-foundation.org>
References: <20080306174209.GA14193@duck.suse.cz>
	<1209166706.6040.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: pbadari@us.ibm.com, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYDZKl6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2008 06:41:58 -0400
In-Reply-To: <1209166706.6040.20.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 25 Apr 2008 16:38:23 -0700 Mingming Cao <cmm@us.ibm.com> wrote:

> Hi,
> 
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

Something like that might be possible, although people used to test
buffered-vs-direct fairly heavily.

generic_file_direct_IO() will run
filemap_write_and_wait()->filemap_fdatawrite() under i_mutex, and this
should run commits, write back dirty pages, etc.

There might remain races though, perhaps with page faults.
