From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Tue, 27 Oct 2009 10:37:15 -0500
Message-ID: <4AE713AB.9060005@redhat.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>	 <4AE67A1B.8060704@redhat.com>	 <a125a870910270117qa90debp8d5a9f90ffb8434@mail.gmail.com>	 <4AE6FC25.3000801@redhat.com> <a125a870910270829u794853c4x370d2bae86499de4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZJ0PhN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 11:37:13 -0400
In-Reply-To: <a125a870910270829u794853c4x370d2bae86499de4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fredrik Andersson wrote:
>> To try to emulate, how does it write into the preallocated space; large or
>> small IOs?  Sequential streaming?  mmap writes?  It may not be relevant but
>> would be nice to try to match it as closely as possible.
> 
> This is a big file that is written sequentially using stdio buffered
> I/O (with a setvbuf of about 4K) in the drdbmake process. No mmap.
> It is regenerated from an earlier version of the same file, and we
> preallocate a file that is 25% bigger than the
> previous version, to allow for more data than was in the previous file
> and to utilize the extent concept in ext4.

FWIW, you do not need to preallocate to get extents.  Preallocation
fundamentally only guarantees space available (somewhere) though in
practice, it can lead to more contiguous allocation of that space since
it's all done up front ...


> We then read the previous file sequentially, update some entries here
> and there and
> rewrite it sequentially into the new, fallocated file. There is one
> single instance of random I/O: Once the whole new
> file has been written, we seek back to the start to write a fixed-size
> header. We then ftruncate the file to the proper size.
> No process is concurrently reading from the file that is being
> written. There is however another process, nodeserv,
> that does random reads from the "previous" file (the one we're
> sequentially reading in drdbmake).
> The deadlock is always in the final ftruncate. It does not help to
> close the file and reopen it again before the ftruncate call.

Thanks.  If find time to think enough about the backtraces you sent
it'll probably be obvious, but the complete description of your workload
is helpful.

Just out of curiosity have you verified that the deadlock doesn't exist
if you skip the preallocation?  I wonder about a fake test where you
simply write a bit extra, and truncate that back.

-Eric

> /Fredrik

