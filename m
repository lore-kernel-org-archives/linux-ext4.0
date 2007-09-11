From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Date: Tue, 11 Sep 2007 09:58:32 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org>
References: <20070911124202.GI9556@shadowen.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	mel@csn.ul.ie
To: Andy Whitcroft <apw@shadowen.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823AbXIKQ7m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2007 12:59:42 -0400
In-Reply-To: <20070911124202.GI9556@shadowen.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Tue, 11 Sep 2007, Andy Whitcroft wrote:
>
> I have a couple of failed test runs against 2.6.23-rc6 where the
> job timed out while running dbench over ext3.  Both on powerpc,
> though both significantly different hardware setups.  A failed
> run like this implies that the machine was still responsive to
> other processes but the dbench was making no progress.  There is
> no console diagnostics during the failure.

Since the machine seems to be otherwise alive, can you do a sysrq-W (which 
is most easily done by just doing a

	echo w > /proc/sysrq-trigger

and you don't actually need any console access or anything like that).

That should give you all the blocked process traces, and if it's a 
deadlock on some semaphore or other, it should all stand out quite nicely.

In fact, things like the above are probably worth scripting for any 
automated testing - if you auto-fail after some time, please make the 
failure case do that sysrq-W by default.

(The other sysrq things can be useful too - "T" shows the same as "W", 
except for _all_ tasks, which is often so verbose that it hides the 
problem, but is sometimes the right thing to do).

			Linus
