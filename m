From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: +
	fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to
	-mm tree
Date: Wed, 13 Jun 2007 16:07:01 -0700
Message-ID: <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net>
	 <20070613134005.GA13815@localhost.sw.ru>
	 <20070613114356.GD17547@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel@vger.kernel.org>, mark.fasheh@oracle.com,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60840 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXFMXFt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 19:05:49 -0400
In-Reply-To: <20070613114356.GD17547@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-06-13 at 13:43 +0200, Nick Piggin wrote:
..
>  
> > 5) ext3_write_end:
> > 	Before  write_begin/write_end patch set we have folowing locking
> > 	order:
> > 		stop_journal(handle);
> > 		unlock_page(page);
> > 	But now order is oposite:
> > 		unlock_page(page);
> > 		stop_journal(handle);
> > 	Can we got any race condition now? I'm not sure is it actual problem,
> > 	may be somebody cant describe this.
> 
> Can we just change it to the original order? That would seem to be
> safest unless one of the ext3 devs explicitly acks it.

It would be nice to go back to original order, but its not that
simple with current structure of the code. With Nick's patches
unlock_page() happens in generic_write_end(). journal_stop() 
needs to happen after generic_write_end(). :(

Mingming, can you take a look at the current & proposed order ?
I ran into bunch of races when I tried to change the order for
->writepages() support earlier :(

Thanks,
Badari
