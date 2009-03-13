From: Frank Mayhar <fmayhar@google.com>
Subject: ext4_mb_generate_buddy and double-free errors
Date: Thu, 12 Mar 2009 17:29:35 -0700
Message-ID: <1236904175.731.12.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:21293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZCMA3l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 20:29:41 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n2D0TcxO017034
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 17:29:38 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We're seeing errors like:
  EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: group 3049: 21020 blocks in bitmap, 21529 in gd

Usually after this the system is cleaned and in the process we see many
"mb_free_blocks: double-free of inode x's block y(bit z in group d)".
(In fact, we see exactly as many of these as the difference between the
group and computed count of free blocks.)

It looks like the bitmap itself is getting messed up somehow, at least
enough to make the free count disagree with the map itself.  Has anyone
else seen something like this?  Any pointers as to where to look for
potential culprits?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

