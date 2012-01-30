From: Eric Whitney <eric.whitney@hp.com>
Subject: 3.2 and 3.1 filesystem scalability measurements
Date: Sun, 29 Jan 2012 23:09:43 -0500
Message-ID: <4F261807.2060108@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17191 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2A3EJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jan 2012 23:09:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've posted the results of some 3.2 and 3.1 ext4 scalability 
measurements and comparisons on a 48 core x86-64 server at:

http://free.linux.hp.com/~enw/ext4/3.2

This includes throughput and CPU efficiency graphs for five simple 
workloads, the raw data for same, plus lockstats on ext4 filesystems 
with and without journals.  The data have been useful in improving ext4 
scalability as a function of core and thread count in the past.

For reference, ext3, xfs, and btrfs data are also included.

The most notable improvement in 3.2 is a big scalability gain for 
journaled ext4 when running the large_file_creates workload.  This 
bisects cleanly to Wu Fengguang's IO-less balance_dirty_pages() patch 
which was included in the 3.2 merge window.

(Please note that the test system's hardware and firmware configuration 
has changed since my last posting, so this data set cannot be directly 
compared with my older sets.)

Thanks,
Eric

