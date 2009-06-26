From: Nick Bowler <nbowler@draconx.ca>
Subject: ext3: massive latencies for some write operations
Date: Thu, 25 Jun 2009 22:18:16 -0400
Message-ID: <97c719fa0906251918i5b047943yde752774c686f301@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: calvin.walton@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:55690 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZFZCSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2009 22:18:14 -0400
Received: by qyk31 with SMTP id 31so2600202qyk.33
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 19:18:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I wasn't entirely sure which list to post this on, this one seemed to
fit best.  Apologies if there was a better place.

Please CC any replies to me me as I am not subscribed to the list.

Recently, I've been experiencing enormous (more than a minute)
latencies during some write operations to my /home filesystem.  During
such a time, many programs tend to completely stop responding,
although programs doing continuous reads (e.g. music or video players)
appear to be unaffected.

The filesystem is a 3TB ext3 filesystem on a software raid-5 array (4x
1TB drives).  Dmesg is completely silent.

I'm on an amd64 running 2.6.30.  However, I had these issues on 2.6.26
and 2.6.29 as well.  Latencytop output follows.

   LatencyTOP version 0.4       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
start_this_handle journal_start ext3_journal_start68746.9 msec         44.3 %
start_this_handle journal_start ext3_journal_start59219.1 msec         38.1 %
sync_page sync_page_killable __lock_page_killable 448.1 msec          2.3 %
sync_buffer __wait_on_buffer ext4_bread ext4_find_445.0 msec          1.6 %
sync_page __lock_page find_lock_page filemap_fault 84.5 msec          0.4 %
do_get_write_access journal_get_write_access __ext 78.2 msec          0.1 %
do_get_write_access journal_get_write_access __ext 70.0 msec          0.0 %
md_write_start make_request md_make_request generi 66.9 msec          0.6 %
sync_buffer __wait_on_buffer ext4_bread ext4_find_ 61.1 msec          0.2 %


Process amuled (19428)                     Total: 69182.1 msec
start_this_handle journal_start ext3_journal_start68746.9 msec         99.4 %do_
sync_page __lock_page find_lock_page filemap_fault 84.5 msec          0.3 %lt do
sync_page sync_page_killable __lock_page_killable  20.9 msec          0.0 %sync_
sync_buffer __wait_on_buffer __ext3_get_inode_loc  15.8 msec          0.0 %looku
sync_buffer __wait_on_buffer __bread ext3_get_bran 11.4 msec          0.0 % ext3
hrtimer_nanosleep sys_nanosleep system_call_fastpa  4.9 msec          0.1 %_read
