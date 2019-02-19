Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9056DC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 10:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D9C2177E
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 10:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZoB+65Ye";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W8Wpr9XM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfBSKU0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:20:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbfBSKU0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2019 05:20:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 91441609C3; Tue, 19 Feb 2019 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550571624;
        bh=J03gcVqxNPsDDBTSK0dIWV201s18cUHgGf7TLBwBHpc=;
        h=Date:From:To:Cc:Subject:From;
        b=ZoB+65Yed3sjqIvjl/P4B6BoBol2BF//4wKVM6FlupilrYFUfYMU/E54f/+WNzWWI
         oamh5iMPjS/OIVphOi/AsFDPv3stj19hW4pPs/+JMStfsMyYfVTS34c2ynGpGlV4j0
         8Fy9VjBZ67f81iiQbkdx7TniPrSz1Xh4QAY2hIxg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 7FC3A609F2;
        Tue, 19 Feb 2019 10:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550571623;
        bh=J03gcVqxNPsDDBTSK0dIWV201s18cUHgGf7TLBwBHpc=;
        h=Date:From:To:Cc:Subject:From;
        b=W8Wpr9XMxm9vHwnVukeMdiBR5cRr4U/CFWjqHYXQ0IgjZu1/kD73g4/0prnVZU1KX
         +ihNbHG98clA0k2ST8/Tia1ymEY1Ua+8prwrTZ1QmoxOmxcA/DW2DIX+1DwRTQVXiU
         j0KWSNZS+bL5qLEFD6UcfUo6LRJkOwy3y3s+QQms=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 Feb 2019 15:50:23 +0530
From:   stummala@codeaurora.org
To:     tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stummala@codeaurora.org
Subject: huge fsync latencies for a small file on ext4
Message-ID: <b1ba05256affe171c2afca6c3aceeb7a@codeaurora.org>
X-Sender: stummala@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

I am observing huge fsync latencies for a small file under the below 
test scenario -

process A -
Issue async write of 4GB using dd command (say large_file) on /data 
mounted
with ext4:
dd if=/dev/zero of=/data/testfile bs=1M count=4096

process B -
In parallel another process wrote a small 4KB data to another file
(say, small_file) and has issued fsync on this file.

Problem -
The fsync() on 4KB file, is taking upto ~30sec (worst case latency).
This is tested on an eMMC based device.

Observations -
This happens when the small_file and large_file both are part of the 
same
committing transaction or when the small_file is part of the running 
transaction
while large_file is part of the committing transaction.

During the commit of a transaction which includes large_file, the jbd2 
thread
does journal_finish_inode_data_buffers() by calling
filemap_fdatawait_keep_errors() on the file's inode address space. While 
this is
happening, if the writeback thread is running in parallel for the 
large_file, then
filemap_fdatawait_keep_errors() could potentially run in a loop of all 
the
pages (upto 4GB of data) and also wait for all the file's data to be 
written
to the disk in the current transaction context itself. At the time
of calling journal_finish_inode_data_buffers(), the file size is of only 
150MB.
and by the time filemap_fdatawait_keep_errors() returns, the file size 
is 4GB
and the page index also points to 4GB file offset in
__filemap_fdatawait_range(), indicating that is has scanned and waited 
for writeback
all the pages upto 4GB and not just 150MB.

Ideally, I think the jbd2 thread should have waited for only the amount 
of data
it has submitted as part of the current transaction and not to wait for 
the
on-going pages that are getting tagged for writeback in parallel in 
another context.
So along these lines, I have tried to use the inode's size at the time 
of calling
journal_finish_inode_data_buffers() as below -

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2eb55c3..e86cf67 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -261,8 +261,8 @@ static int 
journal_finish_inode_data_buffers(journal_t *journal,
                         continue;
                 jinode->i_flags |= JI_COMMIT_RUNNING;
                 spin_unlock(&journal->j_list_lock);
-               err = filemap_fdatawait_keep_errors(
-                               jinode->i_vfs_inode->i_mapping);
+               err = 
filemap_fdatawait_range(jinode->i_vfs_inode->i_mapping,
+                               0, 
i_size_read(jinode->i_vfs_inode->i_mapping->host));
                 if (!ret)
                         ret = err;
                 spin_lock(&journal->j_list_lock);

With this, the fsync latencies for small_file have reduced 
significantly.
It took upto max ~5sec (worst case latency).

Although this is seen in a test code, this could potentially impact the
phone's performance if any application or main UI thread in Android 
issues
fsync() in foreground while a large data transfer is going on in another
context.

Request you to share your thoughts and comments on this issue
and the fix suggested above.

Thanks,
Sahitya.

--
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, 
Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project.
