From: Ted Ts'o <tytso@mit.edu>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Fri, 8 Jul 2011 14:24:25 -0400
Message-ID: <20110708182425.GC3331@thunk.org>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>
 <20110627030539.GF3064@thunk.org>
 <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>
 <F673734C-4ECE-40B2-B283-959027C34B06@mit.edu>
 <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>
 <50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>
 <4E0BBCE9.9020600@nasa.gov>
 <20110630023306.GY2729@thunk.org>
 <4E17398F.2090609@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Sean McCauliff <Sean.D.McCauliff@nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47679 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1GHSY3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 14:24:29 -0400
Content-Disposition: inline
In-Reply-To: <4E17398F.2090609@nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, #1, can you try doing an experiment with "cp -r <src-path>
<dest-path>", and tell me whether the copy speed is faster or slower,
and whether the CPU utilization is faster or slower?  Even if it's a
bit slower to use cp -r, it will be easier for us to try to reproduce
things and to understand what cp -r is doing as opposed to some
mystery java program.

#2, if you know how to set up ftrace, can you enable the
ext4_mballoc_alloc tracepoint and send me a sample output (a few
hundred lines will be plenty).

The short version is basically:

<start your java copy program>
echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_mballoc_alloc/enable
<wait 30 seconds>
cat /sys/kernel/debug/tracing/trace > /var/tmp/trace-save
echo 0 > /sys/kernel/debug/tracing/events/ext4/ext4_mballoc_alloc/enable

						- Ted
