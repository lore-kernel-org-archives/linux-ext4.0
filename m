From: Jan Kara <jack@suse.cz>
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Date: Thu, 14 Jun 2007 11:52:49 +0200
Message-ID: <20070614095249.GG17819@atrey.karlin.mff.cuni.cz>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613114356.GD17547@wotan.suse.de> <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@suse.de>, lkml <linux-kernel@vger.kernel.org>,
	mark.fasheh@oracle.com, ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54480 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXFNJwu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 05:52:50 -0400
Content-Disposition: inline
In-Reply-To: <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 2007-06-13 at 13:43 +0200, Nick Piggin wrote:
> ..
> >  
> > > 5) ext3_write_end:
> > > 	Before  write_begin/write_end patch set we have folowing locking
> > > 	order:
> > > 		stop_journal(handle);
> > > 		unlock_page(page);
> > > 	But now order is oposite:
> > > 		unlock_page(page);
> > > 		stop_journal(handle);
> > > 	Can we got any race condition now? I'm not sure is it actual problem,
> > > 	may be somebody cant describe this.
> > 
> > Can we just change it to the original order? That would seem to be
> > safest unless one of the ext3 devs explicitly acks it.
  Sorry, I've missed beginning of this thread. But what problems can
exactly cause this ordering change? ext3_journal_stop has no need to be
protected by the page lock - it can be even better that it's not
protected as it can trigger commit and all that would happen
unnecessarily under page lock...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
