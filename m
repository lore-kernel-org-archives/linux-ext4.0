Return-Path: <SRS0=BVhb=PR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11904 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbfAIPdc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2019 10:33:32 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 0/4] Write-hint for FS journal
Date: Wed, 09 Jan 2019 21:00:57 +0530
Message-id: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Towards supporing write-hints/streams for filesystem journal.                   
                                                                                
Here is the v1 patch for background -                                           
https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
                                                                                
Changes since v1:                                                               
- introduce four more hints for in-kernel use, as recommended by Dave chinner   
  & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
- remove mount-option to specify write-hint, as recommended by Jan kara &       
  Dave chinner. Rather, FS always sets write-hint for journal. This gets ignored
  if device does not support stream.                                            
- Removed code-redundancy for write_dirty_buffer (Jan kara's review comment)


Kanchan Joshi (4):
  block: Increase count of supported write-hints
  fs: introduce four macros for in-kernel hints
  fs: introduce APIs to enable sending write-hint with buffer-head
  fs/ext4,jbd2: add support for passing write-hint with journal.

 fs/buffer.c                 | 18 ++++++++++++++++--
 fs/ext4/super.c             |  2 ++
 fs/jbd2/commit.c            | 11 +++++++----
 fs/jbd2/journal.c           |  3 ++-
 fs/jbd2/revoke.c            |  3 ++-
 include/linux/blkdev.h      |  5 ++++-
 include/linux/buffer_head.h |  3 +++
 include/linux/fs.h          |  5 +++++
 include/linux/jbd2.h        |  8 ++++++++
 9 files changed, 49 insertions(+), 9 deletions(-)

-- 
2.7.4
