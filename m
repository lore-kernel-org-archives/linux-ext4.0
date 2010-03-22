From: Jan Kara <jack@suse.cz>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Mon, 22 Mar 2010 17:52:09 +0100
Message-ID: <20100322165209.GB4754@quack.suse.cz>
References: <20100211195624.GM739@thunk.org>
 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
 <20100212200726.GD5337@thunk.org>
 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
 <20100215150021.GE3434@quack.suse.cz>
 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
 <20100216131039.GB3153@quack.suse.cz>
 <20100216141854.GT5337@thunk.org>
 <38f6fb7d1002170737l1e9e3b72ub08e106283c26501@mail.gmail.com>
 <38f6fb7d1003182023j5513640csdc797adb49393ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab0CVQv5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Mar 2010 12:51:57 -0400
Content-Disposition: inline
In-Reply-To: <38f6fb7d1003182023j5513640csdc797adb49393ea0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 19-03-10 08:53:08, Kailas Joshi wrote:
> I am facing some problems while implementing alloc_on_commit.
> While performing exhaustive write operations(for example using postmark),
> system locks up after some time.
> It runs fine for (simple)non-exhaustive write operations.
> 
> I am using filemap_write_and_wait() in journal commit callback for
> performing synchronous block allocation. It uses special journal handle
> which enables use of early reservations.
> Is it right to use this function here? If no, is there any other alternative
> that should be used in this scenario?
> 
> I am using following strategy -
> 1) ext4_da_get_block_prep() marks delayed-allocation buffers with BH_DA
> after reserving space for them.
  We have a BH_Delay flag for this already. OK, probably you need a
temporary flag which you can clear in ext4_da_write_begin. I'd find
counting number of BH_Delay buffers before and after block_write_begin
call nicer...

> 2) ext4_da_write_begin() counts the number of buffers marked with BH_DA and
> reserves credits for block allocation.
> 3) journal_stop() accumulates the unused credits of a handle in the
> transaction.
> 4) journal_start() when called with nblocks=0, creates a special handle with
> the credits accumulated by all previous handles(by step 2).
  This is a hack. I'd rather create a separate JBD2 function for this.

> 5) journal_commit() creates special handle for block allocation(as in step
> 4) and calls filemap_write_and_wait() to perform block allocation.
> 
> I am also sending the patch(for kernel 2.6.32.4) for my implementation (also
> available at
> http://www.cse.iitb.ac.in/~kailasjoshi/files/alloc_on_commit.patch).
> 
> Being new to filesystem development, I am not able to identify the problem.
> I will be very greatful if someone can help me out.
  Probably you are hitting some lock inversion problem. I suggest you
compile the kernel with lockdep enabled (in Kernel hacking -> Lock debugging
-> Prove lock correctness or something like that) and see whether it issues
some warnings. If not, you can get backtraces of the locked up processes
by pressing Alt-Sysrq-w (or echo "w" >/proc/sysrq-trigger).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
