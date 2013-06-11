From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] jbd2/log_wait_for_space: drop checkpoint mutex when
 waiting
Date: Tue, 11 Jun 2013 09:03:33 -0400
Message-ID: <20130611130333.GD23966@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-3-git-send-email-paul.gortmaker@windriver.com>
 <20130611023331.GB23966@thunk.org>
 <CAP=VYLofXDGQ5Vjc9S-p1VyVmzYU1ZxcZn5=mDtLZZbtdv9Lig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAP=VYLofXDGQ5Vjc9S-p1VyVmzYU1ZxcZn5=mDtLZZbtdv9Lig@mail.gmail.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 10, 2013 at 11:20:50PM -0400, Paul Gortmaker wrote:
> 
> Absolutely; will do that tomorrow and re-test on 3.10-rc5.

Thanks!!  And by the way, I did look at patches #3 and #4 in your
series, and they looked fine.  If you're going to be resending a new
patch series shortly, I won't bother grabbing them now and wait for
your new series, but if you won't have time to complete your testing,
the patches are independent and easy to validate by inspection, so I
could also just pull them into the ext4 tree earlier.

Cheers, and good luck figuring out the RT problem.

	    	      	       	       - Ted

P.S.  About the bit spinlock patches in the RT Tree...  Something that
might be interesting to do if you have the time is to measure the
performance differential on non-realtime kernels to replace the bit
spinlocks with normal spinlocks.  The two main issues with it I can
forsee is the potential increased memory overhead (since a system can
have a huge number of bh's), but if this were offset with performance
gains (and we can confirm no performance losses moving away from bit
spinlocks), I'm not wedded to keeping them.  Other folks in the
fsdevel community may push back on adding spinlocks to the bh that
many other file systems would have no use for, and that may very well
be a concern, but if we understand what the tradeoffs are, both pro
and con, it's something we can have a reasonable discussion about.

