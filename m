From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Extent tree status asking
Date: Tue, 17 Apr 2012 01:55:34 +0800
Message-ID: <20120416175534.GA5533@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47321 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2DPRtI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 13:49:08 -0400
Received: by dake40 with SMTP id e40so7214486dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 10:49:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

Currently I am trying to reduce the lock contention of direct I/O in ext4
because it is a bottleneck.  A trivial idea is that a new fucntion is
defined to replace the generic_file_aio_write, which do some write
operations with acquiring i_data_sem lock in inode.

I know that you are trying to implement extent tree, and I have seen your patch
set '[PATCH] Rename delayed extents to status extents'.  After extent tree is
made, the implementation of direct I/O without i_mutex and range lock is
straightforward and it is better than my trivial idea.  I think that
maybe I can borrow you works.  So could you please share me your schedule
and/or other information?

Last month on ext4 workshop, we discuss the extent tree, range lock and I/O
tree.  Obviously, I/O tree is used to store I/O operations, which can track
delay allocation, do unwritten->written conversion and implement range lock.
It is very useful for ext4 and I am interested in this proposal.  I know that
you have begun to do some works.  So would you like to tell me the status of
extent tree?  I don't know whether or not there has some things that I can be
involved.  If you have some advices or there is something that I can help,
please let me know.  Thank you and looking forward your reply.

Regards,
Zheng
