From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 22:18:20 +0200
Message-ID: <20090404201820.GA18067@elte.hu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:40069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZDDUSp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 16:18:45 -0400
Content-Disposition: inline
In-Reply-To: <20090404173412.GF5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > Quite frankly, the fact that I can see _seconds_ of latencies 
> > with a really good SSD is not acceptable. The fact that it is by 
> > design is even less so.
> 
> Agree, multi-second latencies is not acceptable.

btw., just to insert some hard data: usability studies place the 
acceptance threshold for delays to around 300 milliseconds.

If the computer does not 'respond' (in a real or a fake, visible or 
audible way) to their input within 0.3 seconds they get annoyed 
emotionally.

It does not matter how complex it is for the kernel to solve this 
problem, it does not matter how far away and difficult to access the 
data is. If we are not absolutely latency centric in Linux, if we 
spuriously delay apps that do supposedly simple-looking things the 
user _will_ get annoyed and _will_ pick another OS.

All things considered it is certainly a combined kernel and app 
problem space to get there, but not being completely aware of its 
importance in the kernel kills any chance of us ever having a 
long-term solution.

	Ingo
