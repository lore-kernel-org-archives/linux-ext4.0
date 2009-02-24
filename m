From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible ext4 race situation freezing linux
Date: Tue, 24 Feb 2009 09:17:49 -0500
Message-ID: <20090224141749.GC5482@mit.edu>
References: <1235478142.11758.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbZBXOR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 09:17:57 -0500
Content-Disposition: inline
In-Reply-To: <1235478142.11758.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 01:22:22AM +1300, Andreas Friedrich Berendsen wrote:
> Kernel version: 2.26.28.7
> efs2progs version: 1.41.4
> arch: x86_64 (amd)
> 
> I made this test four times and the results  were the same: linux
> freezes and becomes unresponsive. Only solution is to reset the box. I
> do not know if the problem is with the USB devices sub-subsystem or a
> possible ext4 race condition.

Can you use alt-sysrq to get some stack traces or a register dump out,
so we can see where the kernel is hanging?

      	      	    	       	  - Ted
