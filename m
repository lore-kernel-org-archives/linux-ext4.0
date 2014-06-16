From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: dump ext4 performance degrades linearly as disk fills
Date: Sun, 15 Jun 2014 22:43:29 -0700
Message-ID: <539E8401.5000607@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:44353 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaFPFnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2014 01:43:42 -0400
Received: from localhost.localdomain (c-67-168-236-90.hsd1.wa.comcast.net [67.168.236.90])
	(authenticated bits=0)
	by josephdwagner.info (8.14.4/8.14.4) with ESMTP id s5G5kLDD032231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2014 01:46:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Background:
- I use lvm snapshots on ext4 for backup.  I use dump to backup the 
snapshots.  The backup goes to an external hard drive over usb 3.0. The 
external hard drive has 1 partition formatted with ext4.

Problem:
- I've noticed the performance of dump to my ext4 backup degrades 
linearly as the disk fills.  In the output, the kbps in the status line 
keeps getting lower as the percent complete keeps getting higher.

My Thoughts So Far:
- I suspect that either 1) dump is doing something which lowers 
performance as the backup progresses, or 2) the ext4 algorithm for 
finding and allocating free blocks is vulnerable to performance 
degradation as the volume fills.

- I haven't tested this thoroughly.  However, performance appears to 
improve when I clear out the external drive and do a fresh, full dump 
(-0), and performance appears to remain degraded on incremental backups 
on a nearly full volume.  This leads me to suspect #2.

Help from you:
- What steps can I take to isolate the cause of the problem?  If there's 
any information I can provide, please let me know.

What I've Done:
- I've run both the short and long SMART tests on the external drive, 
which came back clean.  They also told me the relocated sector count was 
zero.

- I also made sure the disk was connecting in usb 3.0 mode.

- I changed the external drive ext4 mount from journal=ordered to 
journal=writeback.  The performance difference was nominal.

Any insight would be appreciated.

Thanks.

Joseph D. Wagner
