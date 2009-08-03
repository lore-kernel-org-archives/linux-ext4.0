From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Mon, 03 Aug 2009 10:22:01 -0400
Message-ID: <28768.1249309321@gamaville.dokosmarshall.org>
References: <28623.1249307676@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: linux-ext4@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173005pub.verizon.net ([206.46.173.5]:45981 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZHCOWS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 10:22:18 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173005.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KNT003LO18ELPZ0@vms173005.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Mon, 03 Aug 2009 09:21:56 -0500 (CDT)
In-reply-to: Message from Nick Dokos <nicholas.dokos@hp.com> of
 "Mon, 03 Aug 2009 09:54:36 EDT." <28623.1249307676@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos <nicholas.dokos@hp.com> wrote:

> Just a heads-up for now. I ran ll_ver_fs on a 96TB fs - the write phase
> finished without problems, but the read phase encountered a problem:
> 
> ...

> Running a fsck now to see if there are other problems.
> 

The fsck did not find any other problems:


sudo time e2fsck  -t -t -F -n -f /dev/mapper/bigvg-bigvol
e2fsck 1.41.8 (20-Jul-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 284k/1630436k (131k/154k), time: 1055.90/880.05/ 6.00
Pass 1: I/O read: 190MB, write: 0MB, rate: 0.18MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 284k/18014398508112064k (94k/191k), time:  2.33/ 0.93/ 0.92
Pass 2: I/O read: 3MB, write: 0MB, rate: 1.29MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 284k/18014398508635724k (94k/191k), time: 1067.60/888.18/ 9.10
Pass 3: Memory used: 284k/18014398508112064k (86k/199k), time:  0.58/ 0.26/ 0.32
Pass 3: I/O read: 1MB, write: 0MB, rate: 1.71MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 284k/18014398509394812k (85k/200k), time: 147.37/147.08/ 0.27
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 336k/18014398508871152k (86k/251k), time: 1124.59/707.93/18.27
Pass 5: I/O read: 2934MB, write: 0MB, rate: 2.61MB/s
/dev/mapper/bigvg-bigvol: 23950/4289791968 files (0.0% non-contiguous), 24609217723/24609226752 blocks
Memory used: 336k/18014398508871152k (86k/251k), time: 2339.61/1743.19/27.68
I/O read: 3173MB, write: 0MB, rate: 1.36MB/s
1743.18user 31.66system 39:03.59elapsed 75%CPU (0avgtext+0avgdata 0maxresident)k
32603472inputs+0outputs (0major+4403060minor)pagefaults 0swaps


Nick
