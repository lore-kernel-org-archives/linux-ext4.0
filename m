From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 17:03:38 -0400
Message-ID: <1238187818.27455.217.camel@think.oraclecorp.com>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	 <1238187031.27455.212.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:46083 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZC0VEJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 17:04:09 -0400
In-Reply-To: <1238187031.27455.212.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-03-27 at 16:50 -0400, Chris Mason wrote:
> On Fri, 2009-03-27 at 16:24 -0400, Theodore Ts'o wrote:
> > The following patches have been posted as providing at least some
> > partial improvement to the ext3 latency problem that has been
> > discussed on the 2.6.29 mongo-LKML-thread-that-would-not-die.
> 
> Ric had asked me about a test program that would show the worst case
> ext3 behavior.  So I've modified your ext3 program a little.  It now
> creates a 8G file and forks off another proc to do random IO to that
> file.
> 
> Then it runs one fsync every 4 seconds and times how long they take.
> After the program has been running for 60 seconds, it tries to stop.
> 
> On my sata drive with barriers on, even btrfs and xfs saw some
> multi-second fsyncs, but ext3 came in at 414s for a single fsync.
> 
> Warning: don't run this on a laptop drive, you'll still be waiting for
> it next year.  This is probably full of little errors, I cut it together
> pretty quickly.
> 

My understanding of ext4 delalloc is that once blocks are allocated to
file, we go back to data=ordered.  

Ext4 is going pretty slowly for this fsync test (slower than ext3), it
looks like we're going for a very long time in
jbd2_journal_commit_transaction -> write_cache_pages.

-chris


