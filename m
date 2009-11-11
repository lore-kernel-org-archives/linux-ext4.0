From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/2] vfs: tracepoints for buffer flag updates
Date: Thu, 12 Nov 2009 00:09:36 +0530
Message-ID: <20091111183936.GA13999@skywalker.linux.vnet.ibm.com>
References: <1257964260-14020-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42206 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbZKKSji (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2009 13:39:38 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id nABIdhKH015009
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:39:43 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nABIaTTg1581300
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:36:29 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nABIdgHG012008
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:39:42 +1100
Content-Disposition: inline
In-Reply-To: <1257964260-14020-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patchset when enabled with stacktrace will give output like the below

              dd-1905  [003]    26.445155: set_buffer_uptodate: bh = df5c28c0 device = vda block = 34817 new state= 0x23
              dd-1905  [003]    26.445156: <stack trace>
 => set_buffer_uptodate
 => __block_commit_write
 => block_write_end
 => ext3_writeback_write_end
 => generic_file_buffered_write
 => __generic_file_aio_write
 => generic_file_aio_write
 => do_sync_write
              dd-1905  [003]    26.445168: clear_buffer_new: bh = df5c28c0 device = vda block = 34817 new state = 0x23
              dd-1905  [003]    26.445169: <stack trace>
 => clear_buffer_new
 => __block_commit_write
 => block_write_end
 => ext3_writeback_write_end
 => generic_file_buffered_write
 => __generic_file_aio_write
 => generic_file_aio_write
 => do_sync_write
              dd-1905  [003]    26.445182: set_buffer_revokevalid: bh = df406540 device = vda block = 32835 new state= 0x310029
              dd-1905  [003]    26.445183: <stack trace>
 => journal_cancel_revoke
 => do_get_write_access
 => journal_get_write_access
 => __ext3_journal_get_write_access
 => ext3_reserve_inode_write
 => ext3_mark_inode_dirty
 => ext3_dirty_inode
 => __mark_inode_dirty
              dd-1905  [003]    26.445197: clear_buffer_revoked: bh = df406540 device = vda block = 32835 new state = 0x310029
              dd-1905  [003]    26.445198: <stack trace>
 => journal_cancel_revoke
 => do_get_write_access
 => journal_get_write_access
 => __ext3_journal_get_write_access
 => ext3_reserve_inode_write
 => ext3_mark_inode_dirty
 => ext3_dirty_inode
 => __mark_inode_dirty


-aneesh
