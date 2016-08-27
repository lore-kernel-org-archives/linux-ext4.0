From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 stuck at wait_transaction_locked
Date: Sat, 27 Aug 2016 12:14:38 -0400
Message-ID: <20160827161438.miujy357ldsug7be@thunk.org>
References: <CAFz9U7TAWtpQPfgG0u=6_jtVUhK5ahPGGnGy6GK8RZ-0XM2pfg@mail.gmail.com>
 <20160827133642.4znpf3aprhgbdtwv@thunk.org>
 <CAFz9U7SHbv4i=x-2mVYKw5TG_Q9_F+WSp5+jHiHWoQGHJXRmXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Roy Yang <roy@cohesity.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43834 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753958AbcH0QOl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 Aug 2016 12:14:41 -0400
Content-Disposition: inline
In-Reply-To: <CAFz9U7SHbv4i=x-2mVYKw5TG_Q9_F+WSp5+jHiHWoQGHJXRmXw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 27, 2016 at 07:45:57AM -0700, Roy Yang wrote:
> Hi Ted,
>   Thank you very much for reply.
>   The stack trace of the process is killed is:

Hmm, are you sure this is the only process that got oom-killed?  What
I was expecting was a process with a stack trace that showed it was in
the middle of ext4 or jbd2 code at the time when it tried to do a
memory allocation and this either caused an OOM kill, or an EXT4-fs
error report when a memory allocation failed.  

>  We adjust the memory limit and avoid this process is killed. Now the
> problem goes away. If possible, we still want to understand why Ext4
> is stuck in this case.

What is probably happening is that a memory allocation failed in the
middle of an ext4 operation, and it was holding jbd2 handle at the
time of the failure.  The error handling path didn't release the
handle, and so the next time the jbd2 subsystem tried to do a
transaction commit, it waited for all of the handles to complete, and
since there was a handle leak due to the allocation failure / OOM
kill, it caused the jbd2 commit code to wait forever.

If that was the only process that got OOM killed, were there any ext4
error or warning messages before the OOM kill, or maybe slightly after
it?

							- Ted
