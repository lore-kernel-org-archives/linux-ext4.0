From: Jean-Paul Smeets <jean-paul.smeets@asml.com>
Subject: High write latency spikes when writing to EXT4
Date: Fri, 16 Oct 2015 08:07:41 +0000 (UTC)
Message-ID: <loom.20151016T095437-595@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32821 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbbJPIKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2015 04:10:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Zn05U-0003VG-CX
	for linux-ext4@vger.kernel.org; Fri, 16 Oct 2015 10:10:04 +0200
Received: from 195.75.179.148 ([195.75.179.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 10:10:04 +0200
Received: from jean-paul.smeets by 195.75.179.148 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 10:10:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In our application we are seeing occasional high latency spikes (500ms range
)when writing small amounts of data (a couple MB, a couple of 100 IOs) to
files on an EXT4 volume (data=ordered). We are running kernel 3.10.62.

What seems to be happening is that a journal commit takes a long time.
During that time no write access to the journal is possible.
So a subsequent vfs.write is blocked until the journal commit is finished.

We expected the page cache to decouple the vfs.write from this and not to
block the vfs.write.
This behavior causes large spikes in on average much lower write latencies.

Small log excerpt (duration in us): 
16:18:56.966387, PROCA, 20234, __ext4_journal_get_write_access: duration: 140412
16:18:56.966406, PROCB, 19965, __ext4_journal_get_write_access: duration: 461892
16:18:56.966422, PROCC, 20387, __ext4_journal_get_write_access: duration: 391105
16:18:56.966439, PROCD, 20041, __ext4_journal_get_write_access: duration: 64256
16:18:56.966454, itheex, 19823, __ext4_journal_get_write_access: duration:
383671
16:18:56.966718, jbd2/dm-8-8, 684, jbd2_journal_commit_transaction:
duration: 468959
16:18:56.967426, PROCE, 19867, ext4_file_write: duration: 469431
16:18:56.967442, PROCE, 19867, vfs.write: duration: 469452

A similar, but less frequent issue is with the __ext4_journal_start_sb.
Small log excerpt:
16:17:43.337004, PROCF, 20041, __ext4_journal_start_sb: duration: 240753
16:17:43.337024, PROCG, 19980, __ext4_journal_start_sb: duration: 269051
16:17:43.337498, PROCG, 19980, ext4_file_write: duration: 269531
16:17:43.337515, PROCG, 19980, vfs.write: duration: 269554

Can anything be done about these very high latency spikes ?

Best regards,
Jean-Paul Smeets


