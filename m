From: Ted Ts'o <tytso@mit.edu>
Subject: Re: question about fsync
Date: Tue, 26 Oct 2010 18:26:12 -0400
Message-ID: <20101026222612.GB3194@thunk.org>
References: <AANLkTinFkS1Uf+GJT+SE43KpqoUWyJERBFTzxKyLgX+u@mail.gmail.com>
 <5CFF01DA-8C9E-496D-A2F1-D968CFB842EF@mit.edu>
 <AANLkTinTBz6ne37Y=xDeXnQQM39Mk5NYHHfEkHBd-_wP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Filipe David Manana <fdmanana@apache.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43292 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0JZW0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 18:26:17 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinTBz6ne37Y=xDeXnQQM39Mk5NYHHfEkHBd-_wP@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 11:10:15PM +0100, Filipe David Manana wrote:
> Theodore, thanks for your answer.
> 
> A similar question:
> 
> I have 2 threads. Both open the same file, but each using its own
> (different) file descriptor.
> 
> If one thread writes data past the eof (appends data), will the other
> one be able to read it with pread call (an offset past the eof it
> found when it opened the file)?
> 
> I  would just like to know if it's something safe to do on Linux and
> all Posix compliant platforms (and eventually Windows). (I tested this
> with non C code and it worked)

Race conditions aside, yes.

However, note that large writes are not necessarily guaranteed to be
atomic.  Yes, the other thread will be able to read it with a pread
call, but if there is a race between the write() and pread(), it's
possible that pread will only read part of what has been written so
far by the write system call.

						- Ted
