From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Make page_mkwrite() more useful for blocksize < pagesize
Date: Wed, 29 Apr 2009 12:02:46 +0200
Message-ID: <1240999370-27502-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, npiggin@suse.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbZD2KCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 06:02:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  this is a next version of my patches which implement VFS helpers so that
page_mkwrite() is reliably called at the first write access to a page after
the amount of blocks allocated under the page could change. This solves
the problem with filesystems dropping data on the floor when they hit ENOSPC
(or EDQUOT) during writepage().
  The series also contains patches for ext[2-4] showing how the VFS framework
can be used. This is probably not the final version of the patches since I did
some performance measurements with ext3 and allocating blocks on page-fault
time instead of at writepage() time has a significant cost - BerkelyDB based
workloads are slower by ~10% because of much higher file fragmentation
(essentially allocation at writepage time had a kind of delayed allocation
effect for us and it helped a lot in these random write scenarios). I'm
thinking how to solve this so that any filesystem wanting reliable mmap
and reasonable performance behaviour doesn't have to implement something like
delayed allocation or other workaround again...

									Honza
