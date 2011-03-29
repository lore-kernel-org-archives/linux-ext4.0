From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Tue, 29 Mar 2011 10:05:45 -0400
Message-ID: <4731EEFB-561D-4393-81C9-B550F45964C6@mit.edu>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Oren Elrad <elrad@brandeis.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:63033 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab1C2OFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2011 10:05:52 -0400
In-Reply-To: <4D90CE41.4030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mar 28, 2011, at 2:06 PM, Eric Sandeen wrote:
> 
> No other fs that I know of enforces this "don't fill the fs to capacity" 
> common sense programatically, though.

Actually, we (ext2) copied this from the BSD Fast File System (FFS) which used a default MINFREE of 10%.   For ext2 we decided to bring it down to 5%.   FreeBSD currently uses 8% as their default free ratio.

The decrease does seem to be relative to the percentage of free space, from empirical experience, although no one I know of has done a formal analysis of the slowdown.   A lot depends on your workload, how much memory pressure you place on your system, etc.  I've actually started seeing slowdowns starting as early as 80% full when you're trying to allocate large chunks (1M to 8M) at a time, although this isn't something where I've gathered hard data; just what I've noticed from looking at different systems and their performance characteristics.

Fortunately disks are cheap, and lots of people end up buying far more disk space than they need, and so they naturally keep their file systems well under 75-80% full.

If someone wants to add some tuning parameters to mke2fs.conf, so they can set their own personal default free ratios, or even min_reserved_blocks and max_reserved_blocks settings, that's probably a reasonable patch to e2fsprogs that I'd be willing to accept.   I don't think changing the global defaults that we give to users makes sense at this point; I don't think we have enough data (and given what I've seen, the burden of proof should be on those who want to decrease or even eliminate this free ratio --- my fear is that the BSD FFS folks were right, and 8% or 10% is really more appropriate than 5%).

I'd encourage people to run some benchmarks at different levels of fullness, and with different levels of fragmentation.  The FS Impressions tools, which won the 2009 best paper award at FAST (http://www.usenix.org/events/fast09/tech/slides/agrawal.pdf) might be a good place to begin.

-- Ted

