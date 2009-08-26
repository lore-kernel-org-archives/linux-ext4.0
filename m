From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 22:55:14 -0400
Message-ID: <20090826025514.GE32712@mit.edu>
References: <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <20090826011605.GS4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56487 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZHZCz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:55:29 -0400
Content-Disposition: inline
In-Reply-To: <20090826011605.GS4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 03:16:06AM +0200, Pavel Machek wrote:
> Hi!
> 
> > 3) Does that mean that you shouldn't use ext3 on RAID drives?  Of
> > course not!  First of all, Ext3 still saves you against kernel panics
> > and hangs caused by device driver bugs or other kernel hangs.  You
> > will lose less data, and avoid needing to run a long and painful fsck
> > after a forced reboot, compared to if you used ext2.  You are making
> 
> Actually... ext3 + MD RAID5 will still have a problem on kernel
> panic. MD RAID5 is implemented in software, so if kernel panics, you
> can still get inconsistent data in your array.

Only if the MD RAID array is running in degraded mode (and again, if
the system is in this state for a long time, the bug is in the system
administrator).  And even then, it depends on how the kernel dies.  If
the system hangs due to some deadlock, or we get an OOPS that kills a
process while still holding some locks, and that leads to a deadlock,
it's likely the low-level MD driver can still complete the stripe
write, and no data will be lost.  If the kernel ties itself in knots
due to running out of memory, and the OOM handler is invoked, someone
hitting the reset button to force a reboot will also be fine.

If the RAID array is degraded, and we get an oops in interrupt
handler, such that the system is immediately halted --- then yes, data
could get lost.  But there are many system crashes where the software
RAID's ability to complete a stripe write would not be compromised.

       	       	  	     	    	  	- Ted
