From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Getting direct support for fallocate(2) into glibc
Date: Tue, 9 Dec 2008 12:31:28 -0500
Message-ID: <20081209173128.GA19214@mit.edu>
References: <E1L9wQt-0003dz-DE@closure.thunk.org> <493EA3AB.2080308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48569 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbYLIRhU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 12:37:20 -0500
Content-Disposition: inline
In-Reply-To: <493EA3AB.2080308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 09, 2008 at 10:58:19AM -0600, Eric Sandeen wrote:
> ... oh, ok, but plain old fallocate() isn't yet hooked up, odd.
> 
> # gcc -o test-fallocate test-fallocate.c
> /tmp/ccQTk6an.o: In function `main':
> test-fallocate.c:(.text+0x3e): undefined reference to `fallocate'
> 
> Especially odd because we have a man page shipping, but no actual
> implemented interface  :)  OK, I'll go bug people.

Yep, that was what I was referring to.  We have the fallocate(2) man
page because Michael Kerrisk has documented the userspace/kernel
interface.  But that doesn't necessarily mean that glibc has wired up
the interface.  (Sigh, we had been able to push this issue *before*
glibc 2.9 shipped last month, but we were all too busy....)

						- Ted
