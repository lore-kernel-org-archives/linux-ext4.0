From: Jan Kara <jack@suse.cz>
Subject: Re: Error testing ext3 on brd ramdisk
Date: Wed, 18 Mar 2009 14:42:02 +0100
Message-ID: <20090318134202.GB11965@atrey.karlin.mff.cuni.cz>
References: <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net> <20090317094019.GA10360@smart.research.nokia.com> <20090318121116.GC14622@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denis Karpov <ext-denis.2.karpov@gmail.com>,
	"ext Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49218 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZCRNmF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2009 09:42:05 -0400
Content-Disposition: inline
In-Reply-To: <20090318121116.GC14622@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, Mar 17, 2009 at 11:40:19AM +0200, Denis Karpov wrote:
> > Hello, 
> > 
> > first off, sorry if you getting this email twice.
> 
> No problem, I'm not exactly able to reproduce it myself, but Jan Kara
> has just fixed some issues which could explain it: they happen under
> memory pressure so I may not have triggered it if I didn't put it
> under pressure.
> 
> Jan's fixes are here:
> 
> http://marc.info/?l=linux-ext4&m=123731584711382&w=2
> 
> It would be interesting to try them, and if they don't work maybe
> he's also interested so I cc'ed him.
> 
>  
> > I also tried to do ext3/ext4 fs smoketesting and used Adraian's
> > script.  I am consistently getting the same results - filesystem get's
> > corrupted. 
> > I tested on quad Xeon, with patches posted in this thread.
> > 
> > 1. tests with brd:
> > - ext3fs on brd
> >     corruption (see attached ext3fs.brd.corruption.txt)
> > - ext4fs on brd
> >     corruption (see attached ext4fs.brd.corruption.txt)
> > 
> > In both cases I saw some complains from JBD/JBD2:
> >  JBD: Detected IO errors while flushing file data on
  Yes, my patches fix exactly this problem. So please try running with
them. I'm not sure about that HTREE corruption you see during fsck. That
seems to be a separate issue.

> > 2. I enabled JBD debugging, re-run the tests. Console was 
> > flooded with messages and in the end I got a soft lockup.
> > I cannot consistently reproduce this (see attached 
> > brd.ext3fs.softlock.txt).
  Yes, this usually produces far too many messages. The soft lockup was
probably caused by the machine being too busy logging all the messages
(log files are synced which adds much more to the load of the
filesystem). I'd probably leave that aside for now and concentrate on
the corruption problem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
