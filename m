From: Nick Piggin <npiggin@suse.de>
Subject: Re: Error testing ext3 on brd ramdisk
Date: Wed, 18 Mar 2009 13:11:16 +0100
Message-ID: <20090318121116.GC14622@wotan.suse.de>
References: <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net> <20090317094019.GA10360@smart.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "ext Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Denis Karpov <ext-denis.2.karpov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbZCRMPl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 08:15:41 -0400
Content-Disposition: inline
In-Reply-To: <20090317094019.GA10360@smart.research.nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 17, 2009 at 11:40:19AM +0200, Denis Karpov wrote:
> Hello, 
> 
> first off, sorry if you getting this email twice.

No problem, I'm not exactly able to reproduce it myself, but Jan Kara
has just fixed some issues which could explain it: they happen under
memory pressure so I may not have triggered it if I didn't put it
under pressure.

Jan's fixes are here:

http://marc.info/?l=linux-ext4&m=123731584711382&w=2

It would be interesting to try them, and if they don't work maybe
he's also interested so I cc'ed him.

 
> I also tried to do ext3/ext4 fs smoketesting and used Adraian's
> script.  I am consistently getting the same results - filesystem get's
> corrupted. 
> I tested on quad Xeon, with patches posted in this thread.
> 
> 1. tests with brd:
> - ext3fs on brd
>     corruption (see attached ext3fs.brd.corruption.txt)
> - ext4fs on brd
>     corruption (see attached ext4fs.brd.corruption.txt)
> 
> In both cases I saw some complains from JBD/JBD2:
>  JBD: Detected IO errors while flushing file data on
> 
> 2. I enabled JBD debugging, re-run the tests. Console was 
> flooded with messages and in the end I got a soft lockup.
> I cannot consistently reproduce this (see attached 
> brd.ext3fs.softlock.txt).
> 
> Just to be sure I re-run the tests on real block device (usb stick)
> 
> 3. tests with real block device (usb stick)
> - ext3fs
>     no fs currption (overnight run)
> - ext4fs 
>     no fs currption (overnight run)

It's possible the real block device is not fast enough to trigger
it, or different timings don't trigger it (brd requests complete
immediately wheras real devices tend to complete afterwards,
from (soft)interrupt context). 

Or it could be that brd is consuming some more memory to push
the system into reclaim and exposing those bugs Jan has fixed...


> Any ideas what else can be done here? I'd like to find out if this is
> filesystem or brd related fault.

Yes, thanks for persisting. If you can test the patches and see
if they help? If not, does ext2 show corruption? How about ext3
on loop device (with backing file from tmpfs/ramfs for speed).

Thanks,
Nick
