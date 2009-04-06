From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 17:50:34 -0400
Message-ID: <20090406215034.GD3797@csclub.uwaterloo.ca>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <20090404201820.GA18067@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54020 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759781AbZDFVug (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 17:50:36 -0400
Content-Disposition: inline
In-Reply-To: <20090404201820.GA18067@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04, 2009 at 10:18:20PM +0200, Ingo Molnar wrote:
> btw., just to insert some hard data: usability studies place the 
> acceptance threshold for delays to around 300 milliseconds.
> 
> If the computer does not 'respond' (in a real or a fake, visible or 
> audible way) to their input within 0.3 seconds they get annoyed 
> emotionally.

You mean like hitting 'skip commercial' on the remote, and 2 minutes later
when the commercials are almost over, then it happens.  Yeah users get a
bit peeved at that.  Fortunately that particularly behaviour is somewhat
rare.  5 to 10 seconds is more common and sometimes it works fine.

> It does not matter how complex it is for the kernel to solve this 
> problem, it does not matter how far away and difficult to access the 
> data is. If we are not absolutely latency centric in Linux, if we 
> spuriously delay apps that do supposedly simple-looking things the 
> user _will_ get annoyed and _will_ pick another OS.

I would have to get _very_ annoyed before that happened.  I would have
to find a less annoying OS to switch to as well.

> All things considered it is certainly a combined kernel and app 
> problem space to get there, but not being completely aware of its 
> importance in the kernel kills any chance of us ever having a 
> long-term solution.

Certainly my problems are likely to a large extent mythtv's fault.

-- 
Len Sorensen
