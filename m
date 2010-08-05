From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH -v2 0/3] jbd2 scalability patches
Date: Wed, 04 Aug 2010 18:58:57 -0700
Message-ID: <1280973537.2678.37.camel@localhost.localdomain>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51085 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759366Ab0HEB7D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 21:59:03 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o751jC2P009052
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 21:45:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o751x2hU137790
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 21:59:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o751x1eP000788
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 22:59:02 -0300
In-Reply-To: <1280939957-3277-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-08-04 at 12:39 -0400, Theodore Ts'o wrote:
> This version fixes three bugs in the 2nd patch of this series that
> caused kernel BUG when the system was under race.  We weren't accounting
> with t_oustanding_credits correctly, and there were race conditions
> caused by the fact the I had overlooked the fact that
> __jbd2_log_wait_for_space() and jbd2_get_transaction() requires
> j_state_lock to be write locked.

So without the vfs patches, I don't see much change with this patchset
(similar to the last).

novfs + j_state lock
Throughput 763.105 MB/sec 8 procs
Throughput 1056.81 MB/sec 4 procs
Throughput 681.761 MB/sec 2 procs
Throughput 409.25 MB/sec 1 procs

vs

no vfs + j_state lock + jdb2 scalability queue
Throughput 767.778 MB/sec 8 procs
Throughput 1069.58 MB/sec 4 procs
Throughput 679.786 MB/sec 2 procs
Throughput 401.419 MB/sec 1 procs


But with the vfs patchset, there's a nice increase @8cpus.
 vfs + j_state lock
Throughput 1061.44 MB/sec 8 procs
Throughput 1126.55 MB/sec 4 procs
Throughput 706.306 MB/sec 2 procs
Throughput 402.102 MB/sec 1 procs

vs

vfs + j_state lock + jdb2 scalability queue
Throughput 1214.21 MB/sec 8 procs
Throughput 1175.49 MB/sec 4 procs
Throughput 716.294 MB/sec 2 procs
Throughput 402.988 MB/sec 1 procs


I'll post perf log data tomorrow.

thanks
-john



