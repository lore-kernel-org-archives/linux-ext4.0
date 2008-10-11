From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Improve the documentation for ext4's /proc	tunables
Date: Sat, 11 Oct 2008 14:42:33 -0600
Message-ID: <20081011204233.GX2009@webber.adilger.int>
References: <E1Knyha-0004G7-S2@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Alex Tomas <bzzz@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60558 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYJKUm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 16:42:56 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9BKgjj8008923
	for <linux-ext4@vger.kernel.org>; Sat, 11 Oct 2008 13:42:55 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8L00C01DG8QN00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 11 Oct 2008 13:42:45 -0700 (PDT)
In-reply-to: <E1Knyha-0004G7-S2@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 09, 2008  12:49 -0400, Theodore Ts'o wrote:
> So I considered it a moral imperative to rewrite section 1.10 of
> Documentation/filesystems/proc.txt.  I *think* I got the definitions of
> the mballoc tuning parameters correct, but the original text made it
> hard to understand what exactly some of these tuning parameters meant,
> and so I was forced to go RTFS.   Alex, Andreas, could you quickly
> double check the new documentation and make sure I got things right?

Yes, looks reasonable.  A detailed description of mb_history is in the
Lustre user manual section 20.7 (URL below) and your description matches
the remaining manual entries pretty well:
http://manual.lustre.org/manual/LustreManual16_HTML/LustreProc.html#50642991_pgfId-1290686

Parameter	Description

pid		Process that made the allocation.

inode		inode number allocated blocks

goal		Initial request that came to mballoc
		(group/block-in-group/number-of-blocks)

result		What mballoc actually found for this request.

found		Number of free chunks mballoc found and measured before
		the final decision.

grps		Number of groups mballoc scanned to satisfy the request.

cr		Stage at which mballoc found the result:
		0 - best in terms of resource allocation. The request was
		    1MB or larger and was satisfied directly via the kernel
		    buddy allocator.
		1 - regular stage (good at resource consumption)
		2 - fs is quite fragmented (not bad at resource consumption) 
		3 - fs is very fragmented (worst at resource consumption)

queue		Total bytes in active/queued sends.

merge		Whether the request hit the goal. This is good as extents
		code can now merge new blocks to existing extent, eliminating
		the need for extents tree growth.

tail		Number of blocks left free after the allocation breaks large
		free chunks.

broken		How large the broken chunk was. 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

