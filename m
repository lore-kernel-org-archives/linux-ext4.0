From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 11:10:03 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904041106510.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu>
 <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbZDDSMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 14:12:52 -0400
In-Reply-To: <20090404180108.GH5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 4 Apr 2009, Jens Axboe wrote:
> 
> > Also, I may be odd, but I really do think latency is more important than 
> > throughput. When my disk has latencies in the sub-milliseconds, I simply 
> > do not think it is _acceptable_ to have hickups that affect my workload in 
> > human-visible terms. 
> 
> Not everyone has an Intel SSD.

The thing is, I know for a fact that the hickups were much worse _before_ 
I had the Intel SSD.

With the SSD, I have to work a lot more to get them. Back when I had 
regular rotational disks, I definitely did not need to do any 2GB file 
creation at all. Just standard "yum update" would make my mail reader 
pause.

Yeah, it's just for a short time, but it's very annoying. One second is 
quite noticeable when I type something, and it doesn't show up on the 
screen ("What? My Nehalem cannot keep up with my _typing_?"). 2-3 seconds 
it really feels bad. And by the time it takes 5+ seconds, I start moving 
my mouse around just to see whether the computer crashed.

		Linus
