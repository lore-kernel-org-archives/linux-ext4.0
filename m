From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 stuck at wait_transaction_locked
Date: Sat, 27 Aug 2016 09:36:42 -0400
Message-ID: <20160827133642.4znpf3aprhgbdtwv@thunk.org>
References: <CAFz9U7TAWtpQPfgG0u=6_jtVUhK5ahPGGnGy6GK8RZ-0XM2pfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Roy Yang <roy@cohesity.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43510 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbcH0NhS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 Aug 2016 09:37:18 -0400
Content-Disposition: inline
In-Reply-To: <CAFz9U7TAWtpQPfgG0u=6_jtVUhK5ahPGGnGy6GK8RZ-0XM2pfg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 25, 2016 at 11:52:07PM -0700, Roy Yang wrote:
> I need your help to debug one ext4 issue. We consistently see Ext4
> stuck at wait_transaction_locked after another process is killed by
> cgroup because of oom. We have two processes keeping writing data to
> the same disk, and one was killed because of oom; the other process
> will stall at all I/O operations pretty soon.

You're using an ancient, 3.10-based RHEL 7 kernel:

> Linux sedhaswell04-node-1 3.10.0-327.22.2.el7.cohesity.x86_64 #1 SMP
> Tue Jul 5 12:41:09 PDT 2016 x86_64 x86_64 x86_64 GNU/Linux

As far as I know this bug does not exist in the upstream kernel ---
but the 3.10 kernel was released in June 2013, and since then changes
are the responsibility of Red Hat / CentOS.  So you would need to get
support from Red Hat, since they have made a huge number of changes to
the kernel.

If you had given us the stack trace from the task that got OOM-killed,
we might be able to take a quick look, but if you use a distribution
kernel, it is the responsibility of the distribution to support you
--- this is, after all, why they get paid the big bucks.  :-)

If you want to you use the latest upstream kernel, we would be much
more likely to help, although of course unlike Red Hat we don't have
any kind of guaranteed response time.  For that, you would need to go
find a distribution and pay the aforementioned big bucks.  :-)

Cheers,

    	     	   	    	     	  - Ted
					  
