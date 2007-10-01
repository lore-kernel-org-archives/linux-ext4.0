From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] - ext3: fix setup_new_group_blocks locking
Date: Mon, 01 Oct 2007 14:24:16 -0500
Message-ID: <47014960.5060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbXJATYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 15:24:18 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l91JOHlN017180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 15:24:17 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l91JOG2O031296
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 15:24:16 -0400
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l91JOGIS011447
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 15:24:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

setup_new_group_blocks() manipulates the group descriptor block bh
under the block_bitmap bh's lock.  It shouldn't matter since nobody
but resize should be touching these blocks, but it's worth fixing up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.23-rc7/fs/ext3/resize.c
===================================================================
--- linux-2.6.23-rc7.orig/fs/ext3/resize.c
+++ linux-2.6.23-rc7/fs/ext3/resize.c
@@ -212,10 +212,10 @@ static int setup_new_group_blocks(struct
 			brelse(gdb);
 			goto exit_bh;
 		}
-		lock_buffer(bh);
-		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, bh->b_size);
+		lock_buffer(gdb);
+		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
-		unlock_buffer(bh);
+		unlock_buffer(gdb);
 		ext3_journal_dirty_metadata(handle, gdb);
 		ext3_set_bit(bit, bh->b_data);
 		brelse(gdb);
