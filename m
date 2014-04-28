From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [RFC] Defragmentation strategies
Date: Mon, 28 Apr 2014 14:59:14 +0400
Message-ID: <87k3a9d8jh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40755 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaD1K7S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2014 06:59:18 -0400
Received: by mail-lb0-f175.google.com with SMTP id p9so1906760lbv.6
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2014 03:59:16 -0700 (PDT)
Received: from smtp.gmail.com (swsoft-msk-nat.sw.ru. [195.214.232.10])
        by mx.google.com with ESMTPSA id ky2sm9764936lab.16.2014.04.28.03.59.14
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 03:59:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi. 
In ext4 we have EXT4_IOC_MOVE_EXT ioctl which allow to
migrate data block. At this moment the only defragmentation
strategy we have in e4defrag(8) is defragmentation of big files.
But one can imagine different defragmentation strategies for
different file sizes and different purposes. I would like to start a 
discussion about list of strategies which can be usable for us:

* Big file defragmentation
  Good known strategy to make big files
** Example: In fact fragmented for big files may appear only in such cases
   1) Creation big files on FS which has low free space
   2) weird io pattern (multi-threaded small chunks random io + fsync) or
      punch_hole/collapse_range etc.

* Compact small old files to continuous chunks.
**  Example:
     news, mail, web or cache server contains a lot of small files in
     each directory. And files are periodically created and unlinked
     after some period of time. Files has different(unpredictable)
     life-time which result in fragmented fs because block allocator tries
     to compact new files to each other, but later unlink result in
     fragmentation.  In case of thin-provision target this also result
     in significant waste of space.
** Proposed strategy:
   Scan directory and collect small old files it to continuous chunks.
   Core idea is similar to block allocations smaller than
   s_mb_stream_request. But at this moment we have more information about
   file history because if mtime is close to ctime then append is
   unlikely to happen in future so compaction is effective.

* Compact files according to IO access pattern.
  Various tracers may collect statistics about IO access pattern, so
  we can place such block close to each other and reduce number of seeks.
** Example:
   1) Boot io pattern are almost identical across boots
   2) Firefox start-up speedup http://glandium.org/blog/?p=1296
