From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: spinlocks in ext4
Date: Mon, 8 Oct 2012 20:54:25 -0400
Message-ID: <20121009005425.GB20682@thunk.org>
References: <CAK5=ZRLQErM1dOT_Tuf-SC4-3VK_o6TRg-0k8A=iQGgFY6S+aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Fordham <peter.fordham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54497 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JIAy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 20:54:29 -0400
Content-Disposition: inline
In-Reply-To: <CAK5=ZRLQErM1dOT_Tuf-SC4-3VK_o6TRg-0k8A=iQGgFY6S+aw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 04:33:45PM -0700, Peter Fordham wrote:
> 
> Can someone give me a quick outline of why spinlocks are required in
> the EXT4 code? Don't all file-system requests originate from user
> context, hence meaning all locking be done with mutexes or semaphores.

Mutexes are incredibly expensive in the contended case, since you
basically have to take a trip through the scheduler.  If the other CPU
is only going to be holding the lock for a few dozen cycles, a
spinlock is far preferable to a mutex.

> I'm doing some profiling on an ARM device it's showing up spin unlock
> taking a lot of time and I'd like to migrate to using mutex's instead
> since they don't incur penalties from synchronization instructions
> like DMB.  I'm guessing there's some underlying reason why this isn't
> safe and I'd like to understand it.

Why in the world does ARM have expensive spinlocks?  ARM64 is *doomed*
if this is a fundamental property of the ARM processor design...

   	     		 	     	 - Ted
