From: Theodore Tso <tytso@mit.edu>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 5 Jun 2009 14:01:25 -0400
Message-ID: <20090605180125.GB6442@mit.edu>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Aioanei Rares <krnl.list@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34255 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbZFESBb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 14:01:31 -0400
Content-Disposition: inline
In-Reply-To: <4A292E61.3050204@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 05, 2009 at 05:40:33PM +0300, Aioanei Rares wrote:
>> When I upgrade libc from 2.7 (debian stable) to 2.9 (debian unstable),  
>> the locale breaks every reboot, and I have to repair it by running  
>> locale-gen.  This happened now when I only upgraded libc, in order to  
>> play with signalfd().  It also happened before, when I upgraded the  
>> entire machine to debian unstable (which I later reverted).
>>
>> The problem is that /usr/lib/locale/locale-archive gets corrupted when  
>> I reboot.  The exact corruption differs with each reboot (i.e. the  
>> md5sum differs).  Last time, the first ~70K was overwritten with data  
>> from xorg.log and my web browsing history.  I have copies of the  
>> original and corrupted state which I can send, the full file is 1.3  
>> megs, but I can limit it to the first 70K, since that's all that was  
>> corrupted.

> I suspect, although I might be wrong, that this is not a kernel-related
> problem.

Actually, I suspect it is indeed a kernel-related problem.  The
problem has been reported before, with a repeatable test case:

	http://bugzilla.kernel.org/show_bug.cgi?id=13292

The problem shows up after you unmount and remount the filesystem.
Before you the filesystem is unmounted, the locale-archive file has
the correct md5sum.  After you unmount and remount the filesystem, the
filesystem is corrupted.  I'm guessing that some data blocks aren't
getting marked as needing writeback, so the previous contents on disk
aren't written back.  I was able to show that even though the mounted
filesystem had the correct information, direct access to the disk
using debugfs showed the blocks on disk had the contents that would be
revealed after the filesystem was unmounted and remounted.  

The problem only shows up when using ext4 without a journal, and I was
never able to create a simpler reproduction case.  The last time I
tried to work on this bug was approximately a month ago.  About two
weeks ago Frank from Google tried reproducing it, but he wasn't able
to do so using his 2.6.26-based kernel plus an updated ext4.
Unfortunately, I haven't had time to look at it since then, or to
check to see if some of the more recent patches scheduled for the
2.6.31 merge window might have changed the behaviour of this bug.

       	     	    	       	       	   - Ted





