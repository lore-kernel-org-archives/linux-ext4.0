From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 3 Apr 2009 15:13:15 -0400
Message-ID: <20090403191315.GB11661@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <20090403184729.GC5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45511 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZDCTN0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 15:13:26 -0400
Content-Disposition: inline
In-Reply-To: <20090403184729.GC5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03, 2009 at 08:47:29PM +0200, Jens Axboe wrote:
> 
> I have one question, didn't see this series before... Ted, what kind of
> tests did you run with this and on what? 

Well, I've been using it in my default kernel for about a month, and
I've noticed any massive performance issues.  (4GB X61s, with an SSD
as my primary drive and a 5400 rpm disk as my secondary drive).  I
also did testing on my crash and burn machine N270 ATOM netbook, 512
MB memory, 5400rpm drive.

Most of my testing has been on the fsync latency issue plus my
standard filesystem regression for stability (dbench, fsx, etc.)  I
have not done an exhaustive series of performance tests, so you bring
up a good point.

> Currently one has to be careful with WRITE_SYNC, as it also implies
> an immediate unplug of the device.

Yeah, I can definitely see how this could be problematic.  What I
really wanted was to separate out the priority of "things which cause
the user to wait and fume" from "things that are just being dumped out
to disk in the background".  Unplugging the device is definitely *not*
a good thing here, and you're right, it would be better if we fixed
the relatively few places in the code which use WRITE_SYNC to unplug
the queue after all of the writes are submitted.

    	  						- Ted
