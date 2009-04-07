From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Tue, 7 Apr 2009 15:57:59 -0400
Message-ID: <20090407195759.GU3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <20090404201820.GA18067@elte.hu> <20090406215034.GD3797@csclub.uwaterloo.ca> <49DB55B9.7030108@rtr.ca> <20090407144801.GR3795@csclub.uwaterloo.ca> <49DBA7AB.7020409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759879AbZDGT6U@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49DBA7AB.7020409@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 07, 2009 at 03:21:15PM -0400, Mark Lord wrote:
> Mmm.. now that could be problem.
>
> I wonder if mythfrontend is simply getting paged out of memory,
> until you press a button and then the relevant code has to all
> get paged back in again before it can respond (?).

While the video is playing?  Well it is possible I guess.  I haven't had
it happen in a while, so perhaps that was a mythtv bug that got fixed
since the keyboard worked fine if I switch to vt1 for example.

-- 
Len Sorensen
