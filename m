From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Mon, 02 Aug 2010 16:02:32 -0700
Message-ID: <1280790152.3966.14.camel@localhost.localdomain>
References: <1280753306-23871-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:53449 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0HBXCo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 19:02:44 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o72MqrPk017684
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 16:52:53 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o72N2cjl129318
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 17:02:39 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o72N2bg7024282
	for <linux-ext4@vger.kernel.org>; Mon, 2 Aug 2010 17:02:38 -0600
In-Reply-To: <1280753306-23871-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-08-02 at 08:48 -0400, Theodore Ts'o wrote:
> By using an atomic_t for t_updates and t_outstanding credits, this
> should allow us to not need to take transaction t_handle_lock in
> jbd2_journal_stop().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Keith Maanthey <kmannth@us.ibm.com>
> Cc: Eric Whitney <eric.whitney@hp.com>
> ---
> 
> It would be interesting to get some quick performance tests with and
> without this patch on (a) dbench w/ PREEMPT-RT, (b) Keith's 8-way, and
> (c) Eric's 48-core machine.  I have some other ideas for how to improve
> things in start_this_handle(), but they're going to be tricker, and I
> want to do some hard testing using xfstests on a big machine to make
> sure this is really safe before I keep going.  This has passed light
> testing, but I haven't had a chance to do stress tests on a large SMP
> machine yet.  That'll come later this week, hopefully.

So sort of quick and dirty numbers. I'd not trust them too far, but
gives a basic feel for how things are doing.

So this is dbench #s on an 8-core blade:
				1	2	4	8
vfs+j_state lock		401	724	1203	1142
vfs+j_state lock+atomic		408	745	1266	1263
no vfs, no ext4 patches		410	711	1071	434
no vfs, j_state lock		411	714	1113	806
no vfs, j_state lock+atomic	411	723	1149	816

Graphically:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33-rt-ext4-atomic/preempt-rt-ext4-dbench.png


So the vfs-scalability patchset was reverted from -rt due to some
difficult stability issues that were seen in testing. Hopefully we'll be
able to sort them out when -rt moves forward to 2.6.35 or later and we
can use Nick's more cleaned up current queue rather then my poor forward
port of his work from last September.

Anyway, I wanted to show how this patch affects dbench numbers on -rt
both with and without the vfs-scalability patches and the earlier
j_state lock change.

The vfs versions use the 2.6.33-rt23 kernel, and the non vfs use the
2.6.33-rt26 kernel.

>From these numbers, it looks like the atomic variables are a minor
improvement for -rt, but the improvement isn't as drastic as the earlier
j_state lock change, or the vfs scalability patchset.

Didn't run into any troubles with this patch in my testing, but again,
it was a fairly quick set of runs.

thanks
-john



