From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 stuck at wait_transaction_locked
Date: Sat, 27 Aug 2016 15:02:36 -0400
Message-ID: <20160827190236.aoeaphgniuqzwkay@thunk.org>
References: <CAFz9U7TAWtpQPfgG0u=6_jtVUhK5ahPGGnGy6GK8RZ-0XM2pfg@mail.gmail.com>
 <20160827133642.4znpf3aprhgbdtwv@thunk.org>
 <CAFz9U7SHbv4i=x-2mVYKw5TG_Q9_F+WSp5+jHiHWoQGHJXRmXw@mail.gmail.com>
 <20160827161438.miujy357ldsug7be@thunk.org>
 <CAFz9U7RxRLLB7dK7YtEVY9qWKKnQ-AbwpL0MT98jx3urbafJmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Roy Yang <roy@cohesity.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44122 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754684AbcH0TCi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 Aug 2016 15:02:38 -0400
Content-Disposition: inline
In-Reply-To: <CAFz9U7RxRLLB7dK7YtEVY9qWKKnQ-AbwpL0MT98jx3urbafJmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 27, 2016 at 09:29:51AM -0700, Roy Yang wrote:
> Yes, that is the process which was killed by oom killer since it is
> exceeding 1.4GB memory.
> The full dmesg and also processes stuck at ext4
> start_this_handle/wait_transaction_locked
> are attached.

Yeah, unfortunately it's not helpful.  My guess is that it's somewhere
in the call chain of page fault code calling ext4_page_mkwrite() where
we have a bad error handling path, but finding it will be a pain.

Since you have a reliable repro, would you be willing to try and
reproduce the problem with the latest upstream kernel?  If you can
reproduce it there, I'll promise to help you instrument the kernel so
we can track down the problem.

> I also searched Redhat support portal, online resource. Similar issue
> was found but not sure whether
> upstream patch 2c869b262a10ca99cb866d04087d75311587a30c mentioned at
> https://groups.google.com/a/chromium.org/forum/#!topic/chromium-os-checkins/y6n90Mqop7A
> has addressed the problem.

No, this patch fixes a problem with online resize, which has nothing
to do with what you are seeing.

						- Ted
