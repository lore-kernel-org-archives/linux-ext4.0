From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 12:34:50 -0400
Message-ID: <20130626163450.GA2487@thunk.org>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
 <20130626140205.GE3875@thunk.org>
 <20130626145417.GB32092@thunk.org>
 <CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: Nagachandra P <nagachandra@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33147 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3FZQey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 12:34:54 -0400
Content-Disposition: inline
In-Reply-To: <CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 08:50:50PM +0530, Nagachandra P wrote:
> 
> We also have seen case where the current allocation itself could cause
> the lowmem shrinker to be called (which in-turn chooses the same
> process for killing because of oom_adj_value of the current process,
> oom_adj_value is a weight age value associated with each process based
> on which the android low memory killer would select a process for
> killing to get memory). If we chose to retry in such case we could end
> up in endless loop of retrying the allocation. It would be better to
> handle this without retrying.

The challenge is that in some cases there's no good way to return an
error back upwards, and in other cases, the ability to back out of the
middle of a file system operation is incredibly hard.  This is why we
have the retry loop in the jbd2 code; the presumption is that some
other process is scheduable, so that allows other processes to exit
when the OOM killer takes out other processes.

It's not an ideal solution, but in practice it's been good enough.  In
general the OOM killer will be able to take out some other process and
free up memory that way.

Are you seeing this a lot?  If so, I think it's fair to ask why; from
what I can tell it's not a situation that is happening often on most
systems using ext4 (including Android devices, of which I have
several).

> We could your above suggestion which could address this specific path.
> But, there are quiet a number of allocation in ext4 which could call
> ext4_std_error on failure and we may need to look each one of them to
> see on how do we handle each one of them. Do think this something that
> could be done?

There aren't that many places where ext4 does memory allocations,
actually.  And once you exclude those which are used when the file
system is initially mounted, there is quite a manageable number.  It's
probably better to audit all of those and to make sure we have a good
error recovery if any of these calls to kmalloc() or
kmem_cache_alloc() fail.

In many of the cases where we end up calling ext4_std_error(), the
most common cause of is an I/O error while trying to read some
critical metadata block, and in that case, declaring that the file
system is corrupted is in fact the appropriate thing to do.

> We have in the past tried some ugly hacks to workaround the problem
> (by adjusting oom_adj_values, guarding them from being killed) but
> they don't seem provide fool proof mechanism at high memory pressure
> environment. Any advice on what we could try to fix the issue in
> general would be appreciated?

What version of the kernel are using?  And do you understand why you
are under so much memory pressure?  Is it due to applications not
getting killed quickly enough?  Are applications dirtying too much
memory too quickly?  Is write throttling not working?  Or are they
allocating too much memory when they start up their JVM?  Or is it
just that your Android device has far less memory than most of the
other devices out there?

Speaking generally, if you're regularly seeing that kmem_cache_alloc
failing, that means free memory has fallen to zero.  Which to me
sounds like the OOM killer should be trying to kill processes more
aggressively, and more generally you should be trying to be trying to
make sure the kernel is maintaining a somewhat larger amount of free
memory.  The fact that you mentioned trying to prevent certain
processes from being killed may mean that you are approaching this
problem from the wrong direction.  It may be more fruitful to
encourage the system to kill those user applications that most
deserving _earlier_.

Regards,

					- Ted
