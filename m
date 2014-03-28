From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 28 Mar 2014 10:23:52 +0000
Message-ID: <bug-71641-13602-QpiNRvZo60@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaC1KX6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2014 06:23:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 47C97202A7
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2014 10:23:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 80D75202EC
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2014 10:23:52 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #9 from Chia-Hung Chang <fredchang.tc@gmail.com> ---
(In reply to Theodore Tso from comment #8)
> it's clear this isn't going to get performance up to 1.1 GB/s, but I'm
> curious how much setting JBD2_NR_BATCH changes things at 512 and 1024 and
> possibly even 2048.   Once it no longer maters a difference, if you could do
> another blktrace, and also gather lock_stat information, that would be
> useful.
> 
> To gather lock_stat information, enable CONFIG_LOCK_STAT, and then "echo 0 
> > /proc/lock_stat" before you start the workload, and then capture the
> output of /proc/lock_stat after you finish running your workload/benchmark.
> 
> If you also regather numbers with lock_stat enabled on a stock 3.11 kernel
> (and also get a /proc/lock_stat report from a stock 3.11 kernel, with and
> without data=journal), that would be useful.
> 
> If it turns out that there is some lock contention going on with some of the
> jbd2 spinlocks, there are some patches queued for 3.15 that I may have to
> ask you to try (which will mean going to something like 3.14-rc7 plus some
> additional patches from the ext4 git tree).
> 
> Thanks for your benchmarking!

Thanks for your advice.
With the same environment setting and 'dd' command,
The benchmarks of JBD2_NR_batch with data=journal are showed as following,

JBD2_NR_batch =64   ->386 MB/s

JBD2_NR_batch =254  ->400MB/s

JBD2_NR_batch =512  ->407MB/s

JBD2_NR_batch =1024 with  CONFIG_LOCK_STAT enable ->304MB/s

JBD2_NR_batch =2048 ->440MB/s

---------------------------
/proc/lock_stat report with data=journal

data collected at the end of "dd"
https://dl.dropboxusercontent.com/u/32959539/lock_stat_result

data collected in the middle of "dd" execution
https://dl.dropboxusercontent.com/u/32959539/lock_stat_result2

/proc/lock_stat report with data=ordered
https://dl.dropboxusercontent.com/u/32959539/lock_stat_ordered

------------------------------
blktrace of JBD2_NR_batch =2048 with data=journal
https://dl.dropboxusercontent.com/u/32959539/JBD2_NR_batch_2048.7z


Please tell me if you need further information.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
