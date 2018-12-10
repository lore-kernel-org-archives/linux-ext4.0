Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23530 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbeLJMwt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 07:52:49 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com, axboe@kernel.dk,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 0/2] fs,ext4,jbd2: Specifying write-hint for Ext4 journal
Date: Mon, 10 Dec 2018 18:20:02 +0530
Message-id: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
References: <CGME20181210125245epcas2p202bc4336e91a55cee3786ed6abffea05@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For NAND-based SSDs, mixing of data with different life-time reduces            
efficiency of garbage-collection. During FS operations, series of journal       
updates will follow/precede series of data/meta updates, causing intermixing    
inside SSD. By passing a write-hint (a.k.a stream) with journal, its writes     
can be isolated from other meta/data writes, leading to performance/endurance   
benefit on multi-stream SSD.                                                    
This is described in greater detail (along with results) in this "FAST 2018"    
paper - https://www.usenix.org/system/files/conference/fast18/fast18-rho.pdf    
                                                                                
This patch is split into two parts. First patch introduces APIs to send         
write-hint with buffer-head. Second one implement "journal_writehint" mount     
option (inspired from "journal_ioprio") in Ext4/JBD2.

Kanchan Joshi (2):
  fs: introduce APIs to enable sending write-hint with buffer-head
  fs/ext4,jbd2: Add support for passing write-hint with journal.

 fs/buffer.c                 | 21 +++++++++++++++++++++
 fs/ext4/super.c             | 33 +++++++++++++++++++++++++++------
 fs/jbd2/commit.c            | 11 +++++++----
 fs/jbd2/journal.c           |  2 +-
 fs/jbd2/revoke.c            |  2 +-
 include/linux/buffer_head.h |  3 +++
 include/linux/jbd2.h        |  7 +++++++
 7 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.7.4
