From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 9546] New: Huge latency in concurrent I/O when using data=ordered
Date: Wed, 12 Dec 2007 10:15:27 +0100
Message-ID: <20071212091527.GA17448@atrey.karlin.mff.cuni.cz>
References: <bug-9546-27@http.bugzilla.kernel.org/> <20071211133127.432592c1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	casteyde.christian@free.fr
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48656 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbXLLJP2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Dec 2007 04:15:28 -0500
Content-Disposition: inline
In-Reply-To: <20071211133127.432592c1.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> (switching to email - please respond via emailed reply-to-all, not via the
> bugzilla web interface)
> 
> On Tue, 11 Dec 2007 11:36:39 -0800 (PST)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9546
> > 
> >            Summary: Huge latency in concurrent I/O when using data=ordered
> >            Product: File System
> >            Version: 2.5
> >      KernelVersion: 2.6.24-rc4
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: ext3
> >         AssignedTo: akpm@osdl.org
> >         ReportedBy: casteyde.christian@free.fr
> > 
> > 
> > Most recent kernel where this bug did not occur:
> > Unknown, certainly not a regression, but something specific to ext3 algorithm
> > 
> > Distribution:
> > Bluewhite64 12 (Slackware 12 64 bits port) and Slackware 12
> > 
> > Hardware Environment:
> > Athlon 64 3000+laptop IDE 5400 80GB+1.2GB RAM
> > Athlon 64X2 4200+SATA 7200 200GB drive+1GB
> > Athlon 2800+IDE 7200 40GB drive+512MB
> > 
> > Software Environment:
> > dd, cp, konqueror/KDE, mount/tune2fs
> > 
> > Problem Description:
> > When the system does heavy input/output operations on big files, small files
> > access from other applications are always not served for very long time. This
> > can cause huge latencies. The system is really not usable at all, even with all
> > the recent improvements done to increase interactivity on desktop.
> > 
> > This behaviour is very visible with the simple following test case:
> > 1. Build a DVD structure from big MPEG+PS files with dvdauthor (it copies the
> > files in the DVD stucture, then pass on them to fix VOBUs, but this part is not
> > very long so this is not the main problem).
> > 2. While the computer is doing this, try to open a web browser such as
> > konqueror. Then open a page from bookmark. Then open a new tab, then open
> > another page from bookmark. Switch bak to first page.
> > 
> > What I get is:
> > 35 seconds to open Konqueror.
> > 8 seconds to open the "bookmark menu". Incredible.
> > 30 seconds to open the web page (DSL/10GBits).
> > 5 seconds to open the second tab.
> > 6 seconds to reopen the menu.
> > 36 seconds to open the second page.
> > 14 seconds to come back to first tab.
> > This is unbelievable! The system is completely trashed, with more than 1GB RAM,
> > whatever the hardware configuration is used.
> > 
> > Of course, I investigated the problem... First, DMA is OK. Second, I thought
> > cache would make memory swapped. So I used echo 0 > swapiness. Then (of course,
> > the system was not swapping at all), I thought TEXT sections from software
> > discarded (that would be simply stupid, but who knows?). I then tried to make
> > the writing process throttled with dirty_background_ratio (say 10%) while
> > reserving a greater RAM portion for the rest of the system with dirty_ratio
> > (say 70%). No way. Then I launched top, and looked at the WCHAN to see what was
> > the problem for the frozen process (ie: konqueror). The I saw the faulty guy:
> > log_wait_commit!
> > 
> > So I concluded there is unfair access to the filesystem journal. So I tried
> > other journaling options than the default "ordered" data mode. The results were
> > really different: "5s, 2s, 4s, etc.", both with journal and write back mode!
> > 
> > I therefore think there is a great lock and even maybe a priority inversion in
> > log_wait_commit of the ext3 filesystem. I think that, even if it is throttled,
> > the writing process always get access to the journal in ordered mode, simply
> > because it writes many pages at a time and because the ordered mode indeed
> > implies... ordering of requests (as I understand it).
> > 
> > It's sad this is the default option that gives the worst interactivity
> > problems. Indeed, this messes all previous work done to enhance desktop
> > experience I think, too bad!
> > 
> > Btw, I've also seen on Internet that some people reported that journal data
> > mode gives "better" performance. I think the problem was indeed related to
> > latency rather than performance (timing the writing process effectively shows a
> > output rate halved with journal data mode, and twice the time to process).
> > 
> > Steps to reproduce:
> > I did a simple script:
> > #!/bin/bash
> > 
> > SRC1=src1.bin
> > SRC2=src2.bin
> > DEST_DIR=tmpdir
> > DST1=dst.bin
> > 
> > # First, create the source files:
> > if [ ! -e $SRC1 ] ; then
> >         dd if=/dev/zero of=$SRC1 bs=10k count=150000
> > fi
> > if [ ! -e $SRC2 ] ; then
> >         dd if=/dev/zero of=$SRC2 bs=10k count=150000
> > fi
> > mkdir $DEST_DIR > /dev/null 2>&1
> > sync
> > 
> > # Do the test:
> > echo "Trashing the system..."
> > rm $DEST_DIR/$DST1 > /dev/null 2>&1
> > cp $SRC1 $DEST_DIR/$DST1
> > cat $SRC2 >> $DEST_DIR/$DST1
> > echo "Done!"
> > 
> > #rm -rf $DEST_DIR $SRC1 $SRC2
> > 
> > While running it, try to use "normally" the interactive programs, such as
> > konqueror (the program should have to access files, such as cookies, cache and
> > so for konqueror). Then remount/tune the filesystem to use another data mode
> > for ext3.
> > 
> > I didn't try with other journaling filesystems. I guess ext2 also doesn't
> > exhibit the problem.
> > 
> 
> Interesting that data=writeback helped this.  You don't give a lot of
> details, but I assume that data=writeback made a large difference here?
  What I think could be happening:
One process does data-intensive load. Thus in the ordered mode the
transaction is tiny but has tons of data buffers attached. If commit
happens, it takes a long time to sync all the data before the commit
can proceed... In the writeback mode, we don't wait for data buffers, in
the journal mode amount of data to be written is really limited by the
maximum size of a transaction and so we write by much smaller chunks
and better latency is thus ensured.
  I'll try some tests to verify whether my theory is correct :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
