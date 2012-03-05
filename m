From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't release page refs in ext4_end_bio()
Date: Mon, 5 Mar 2012 10:42:13 -0500
Message-ID: <20120305154213.GC21356@thunk.org>
References: <1330705199-12512-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52951 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2CEPmR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 10:42:17 -0500
Content-Disposition: inline
In-Reply-To: <1330705199-12512-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 08:19:59AM -0800, Curt Wohlgemuth wrote:
> We can clear PageWriteback on each page when the IO
> completes, but we can't release the references on the page
> until we convert any uninitialized extents.
> 
> Without this patch, the use of the dioread_nolock mount
> option can break buffered writes, because extents may
> not be converted by the time a subsequent buffered read
> comes in; if the page is not in the page cache, a read
> will return zeros if the extent is still uninitialized.
> 
> I tested this with a (temporary) patch that adds a call
> to msleep(1000) at the start of ext4_end_io_work(), to delay
> processing of each DIO-unwritten work queue item.  With this
> msleep(), a simple workload of
> 
>   fallocate
>   write
>   fadvise
>   read
> 
> will fail without this patch, succeeds with it.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, applied.

					- Ted
