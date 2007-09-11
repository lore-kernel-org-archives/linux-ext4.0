From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Date: Tue, 11 Sep 2007 18:55:35 +0200
Message-ID: <20070911165535.GA23520@atrey.karlin.mff.cuni.cz>
References: <20070911124202.GI9556@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>, mel@csn.ul.ie
To: Andy Whitcroft <apw@shadowen.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59775 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXIKQzg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 12:55:36 -0400
Content-Disposition: inline
In-Reply-To: <20070911124202.GI9556@shadowen.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I have a couple of failed test runs against 2.6.23-rc6 where the
> job timed out while running dbench over ext3.  Both on powerpc,
> though both significantly different hardware setups.  A failed
> run like this implies that the machine was still responsive to
> other processes but the dbench was making no progress.  There is
> no console diagnostics during the failure.
> 
> beavis was lost during a plain ext3 dbench run, having just
> successfully run a complete ext2 run.  elm3b19 was lost during an
> ext3 "data=writeback" dbench run, having already completed an plain
> ext2, and ext3 runs.
  OK, thanks for report.

> A quick poke at the dbench logs on the second machine shows this
> for the working ext3 dbench run:
> 
>   4 clients started
>   4     35288  814.49 MB/sec
>   0     62477  822.99 MB/sec
>   Throughput 822.954 MB/sec 4 procs
> 
> Whereas the hanging run shows the following continuing until the
> machine is reset, which confirms that the machine as a whole was
> still with us:
> 
>   4 clients started
>   4     36479  824.92 MB/sec
>   1     46857  519.98 MB/sec
>   1     46857  346.65 MB/sec
>   1     46857  259.99 MB/sec
>   1     46857  207.99 MB/sec
>   1     46857  173.32 MB/sec
>   1     46857  148.56 MB/sec
>   1     46857  129.99 MB/sec
>   1     46857  115.55 MB/sec
>   1     46857  103.99 MB/sec
>   1     46857  94.54 MB/sec
>   1     46857  86.66 MB/sec
>   1     46857  80.00 MB/sec
>   [...]
  So the process doing IO is hung. Could you dump stack of all the tasks
(Alt-Sysrq-t) and send the output? We've probably deadlocked
somewhere...

> The first machine is very similar:
> 
>   4 clients started
>   4     18468  445.29 MB/sec
>   4     41945  469.36 MB/sec
>   1     46857  346.68 MB/sec
>   1     46857  260.00 MB/sec
>   1     46857  208.00 MB/sec
>   [...]
> 
> Not sure if there is any significance to the 46857.  Though it feels
> like we may be at the end of the run when it fails.
> 
> I will try and reproduce this on one of the machines and see if I
> can get any further info.

								Honza
