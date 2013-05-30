From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: [Bug 968876] e4defrag incorrectly calculates optimum extents
Date: Thu, 30 May 2013 11:19:26 -0700
Message-ID: <7516c4d492bad2bbb810a779816fcea5@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:41153 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3E3TR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 May 2013 15:17:28 -0400
Received: from josephdwagner.info (josephdwagner.info [72.4.161.242])
	(authenticated bits=0)
	by josephdwagner.info (8.14.4/8.14.4) with ESMTP id r4UIJRt7025702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 30 May 2013 14:19:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.redhat.com/show_bug.cgi?id=968876

The "Total/best extents" calculation for done in the e4defrag program 
doesn't seems to not consider the limit of 32768 file system blocks (see 
/usr/src/linux/fs/ext4/ext4_extents.h comment EXT_INIT_MAX_LEN) in an 
extent when computing the "best" value. It seems to presume 2G is the 
best extent size, but on a file system with a 4kb block size the largest 
available extent is 128M not 2G.

(The best extent size calculation in e4defrag seems to be based on 
block group size but the underlying implementation in the kernel is 
limited to a __le16 blocks and uses up one whole bit of that to flag 
whether the extent is initialized, which actually produces a one-block 
perturbation in the actual limit based on how the extent was allocated 
(e.g. whether falloc used FS_KEEP_SIZE or not), go go gadget perturbed 
math. 8-)).

Example:
-rw-r--r-- 1 rwhite rwhite 5.0G Jun 13 16:28 CentOS.qcow2

yeilds output: (where "/3" is wrong).

Total/best extents 152/3

Proposed patch available here:
http://pastebin.com/9XTFcVM0

Joseph D. Wagner
