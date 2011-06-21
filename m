From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Help required for Debugging JBD
Date: Tue, 21 Jun 2011 22:22:06 +0530
Message-ID: <4E00CC36.80707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41488 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1FUQye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 12:54:34 -0400
Received: by qwk3 with SMTP id 3so1397599qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 09:54:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
         I have modified my JBD (no change to Ext3) to support 
Transactional-Flash. For that I require only to collect metadata and 
data blocks and send them simultaneously (no transaction record, revoke 
record etc).
        The problem is, though it works well for small number of 
operations, the kernel completely hangs when I run any benchmark (like 
blogbench or postmark) over them. The bad thing is that there is no 
trace left afterwards, ie logs don't contain any message since the 
operation was started, kernel OOPS are not shown, no faults are shown, 
no panic is shown even though I have enabled panic on hard/soft lockup. 
I have to hard reboot machine each time.
         So essentially, I am totally clueless about the point  at which 
it is crashing or reason behind it. There is a small possibility that 
bug may be in modified MTD layer (which I've written myself), but since 
I have run unmodified Ext3 on that MTD layer without any bug, the chance 
of buggy MTD layer appears very slim.

Any help in greatly appreciated.

Niraj
