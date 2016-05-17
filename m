From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add lazyinit stats support
Date: Tue, 17 May 2016 02:13:23 -0400
Message-ID: <20160517061323.GY7799@thunk.org>
References: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
 <e7de9f2f-6a12-026c-c9fb-2e676fdc37e4@redhat.com>
 <CAP9B-Q=7BUzkODy_PAsWi3YT3pYBcqMDWPR6kR6pCqFMDa_tzA@mail.gmail.com>
 <43a7d624-5fd1-a3a5-5f18-a84ebde86f1f@redhat.com>
 <20160517044507.GW7799@thunk.org>
 <71C04976-407D-4B88-9EFD-923636E69ACB@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"adilger@dilger.ca" <adilger@dilger.ca>
To: Shuichi Ihara <sihara@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33062 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcEQGN2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 02:13:28 -0400
Content-Disposition: inline
In-Reply-To: <71C04976-407D-4B88-9EFD-923636E69ACB@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 05:36:57AM +0000, Shuichi Ihara wrote:
> Sure, disabling layzinit is an option, but our single disk size is
> more than 60TB to make several petabyte system with Lustre.
> It takes time in a long while to be completion of mkfs without
> layzinit and we can't do anything until mkfs is done.  layzinit is
> still help, we can mount filesystem and do something (create Lustre
> and testing from client, etc) in parallel under lazyinit is running
> behind.

Ah, I'm used to doing single disk benchmarks where in the interests of
getting numbers which are as reproducible as possible, I always run
the performance benchmarks on a freshly initialized file system, and
so I don't want to do anything between when the file system is
initialized and when the workload is started --- or if I'm going to be
running a test on an aged file system, I'll have a standardized file
system aging tool with a fixed random seed, and/or a file system image
which I'll dd into place so that the starting point for the
performance evaluation is exactly the same for each benchmark run.

It didn't occur to me that you might want to be using the file system
while lazy init was taking place, and then later on, doing the
performance benchmarks on a used, randomly dirtied file system.  Hence
my assumption that the benmarking shell script[1] would not be doing
anything at all while it waited for lazy init to be finished.

[1] In the interests of keeping the results as consistent as possible,
I tend to have benchmarking scripts that do all of the workload setup
and test running and data collection done in an automated fashion, so
I can kick off a benchmarking run and come back the next day (or after
the weekend) with all of the results collected.

	    	       	    	  - Ted
