From: Mingming Cao <cmm@us.ibm.com>
Subject: Possible race between direct IO and JBD?
Date: Fri, 25 Apr 2008 16:38:23 -0700
Message-ID: <1209166706.6040.20.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: pbadari@us.ibm.com, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39175 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbYDYXi4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 19:38:56 -0400
In-Reply-To: <20080306174209.GA14193@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While looking at a bug related to direct IO returns to EIO, after
looking at the code, I found there is a window that
try_to_free_buffers() from direct IO could race with JBD, which holds
the reference to the data buffers before journal_commit_transaction()
ensures the data buffers has reached to the disk.

A little more detail: to prepare for direct IO, generic_file_direct_IO()
calls invalidate_inode_pages2_range() to invalidate the pages in the
cache before performaning direct IO.  invalidate_inode_pages2_range()
tries to free the buffers via try_to free_buffers(), but sometimes it
can't, due to the buffers is possible still on some transaction's
t_sync_datalist or t_locked_list waiting for
journal_commit_transaction() to process it. 

Currently Direct IO simply returns EIO if try_to_free_buffers() finds
the buffer is busy, as it has no clue that JBD is referencing it.

Is this a known issue and expected behavior? Any thoughts?


Mingming

