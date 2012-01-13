From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: working on extent locks for i_mutex
Date: Thu, 12 Jan 2012 20:01:43 -0700
Message-ID: <4F0F9E97.1090403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55484 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2AMDCZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 22:02:25 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 12 Jan 2012 22:02:23 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0D31kEH1896548
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 22:01:47 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0D31j44022000
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 22:01:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I know this is an old topic, but I am poking it again because I've had 
some work items wrap up, and Im planning on picking up on this one 
again.  I am thinking about implementing extent locks to replace 
i_mutex.  So I just wanted to touch base with folks and see what people 
are working on because I know there were some folks out there that were 
thing about doing similar solutions.

A while ago I had done some investigation on where i_mutex is currently 
used, so I did a review and updated my list.  Only one thing had been 
removed, but I will leave the list here since it was a while ago.  Let 
me know if anyone has been working on similar concept.  Thx!

Allison


List of ext4 functions that lock i_mutex:
ext4_sync_file
ext4_fallocate
ext4_move_extents via two helper routines:
     mext_inode_double_lock and mext_inode_double_unlock
ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
ext4_quota_write
ext4_llseek
ext4_end_io_work
ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)


Functions called by vfs with i_mutex locked:
ext4_setattr
ext4_da_writepages
ext4_rmdir
ext4_unlink
ext4_symlink
ext4_link
ext4_rename
ext4_get_block

