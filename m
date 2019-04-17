Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7E4C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D836F2064B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kSt3wdcK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbfDQRxx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:53:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56111 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbfDQRxx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:53:53 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190417175348epoutp0473c9211d8c57888de6d7dafc1ac4dc77~WVH_srMxE0246902469epoutp04y;
        Wed, 17 Apr 2019 17:53:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190417175348epoutp0473c9211d8c57888de6d7dafc1ac4dc77~WVH_srMxE0246902469epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523628;
        bh=HWF9wssniCzlufvKqNxRQobMFul7STeiB7FnbtGZJPw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kSt3wdcKUSLVAuDoe0LI+/rtzHTtw5R1Uch+xLP1hdvZH09dSn1J72SBs0PnI7jxQ
         mMUZoITxsYWBn8ocBzxtKqiBqmnY57dhhRVPwoclXkGKjRK2AqSVMfuaNvF6YDVZ0D
         oHDi5pSbnArNapYaSlgHkcHVl2eBPpgfnAVLdiBk=
Received: from epsmges2p1.samsung.com (unknown [182.195.42.69]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190417175348epcas2p2ae85fa853d3455704af13e3e35b1516c~WVH_eU6RB2741727417epcas2p2w;
        Wed, 17 Apr 2019 17:53:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.A3.04195.C2867BC5; Thu, 18 Apr 2019 02:53:48 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20190417175347epcas2p41e4240ab83b46c9f07d237fc9494903a~WVH9-PMMS2024920249epcas2p4y;
        Wed, 17 Apr 2019 17:53:47 +0000 (GMT)
X-AuditID: b6c32a45-d47ff70000001063-0c-5cb7682cbb09
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.EF.03620.B2867BC5; Thu, 18 Apr 2019 02:53:47 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:53:47 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 0/7] Extend write-hint/stream infrastructure
Date:   Wed, 17 Apr 2019 23:19:59 +0530
Message-id: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdljTVFcnY3uMwZYmUYuj/9+yWey9pW0x
        c94dNos9e0+yWFzeNYfNYv6yp+wWV6YsYnZg99i8pN6jb8sqRo/Pm+QCmKO4bFJSczLLUov0
        7RK4Mp5/aGAtOChacXf/MuYGxpX8XYycHBICJhIzns9h6WLk4hAS2MEoceDhXSYI5zujRPux
        LjaYqnMzWhkhErsZJbZvvMYK4Uxnkuj/uIa9i5GDg01AU+LC5FKQuIjAHEaJZfumMYN0MwvY
        Scz49poVpEZYwF6ia5cFSJhFQFXi1vEzYAt4BZwk5lx+xgqxTE7i5rlOZpA5EgIPWSVePz8C
        dYWLxN5Dh6FsaYlnqzYyQtjFEr/uHIVq6GCUuN4wkwUiYS9xcc9fJogj+CQ6Dv8FO1RCgFei
        o00IosRD4sy/CewgtpBArMTk16eYJjCKL2BkWMUollpQnJueWmxUYKhXnJhbXJqXrpecn7uJ
        ERw1Wq47GGec8znEKMDBqMTDu0J1e4wQa2JZcWXuIUYJDmYlEV7HlC0xQrwpiZVVqUX58UWl
        OanFhxilOViUxHkfSc+NFhJITyxJzU5NLUgtgskycXBKNTC+FD3gvuoXc5Cw2HJuNfkbemsb
        9OqjVxk48KX0NZ1IeSm9PliomOn1r/lTAw7Pe/Fw0pbuYzG+zJ0SL03zshN5Fxpl5nkziTta
        PFjN9oHJquuYaU+EwB6tr7ffcNZMqatoq1isKntKT9B7c/jd152Hk9LEzz3++f1q5a7iOpb0
        +tkRLp47qpVYijMSDbWYi4oTASq1SliWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAV3tjO0xBiv2GVgc/f+WzWLvLW2L
        mfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDu8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqk
        b5fAlfH8QwNrwUHRirv7lzE3MK7k72Lk5JAQMJE4N6OVsYuRi0NIYCejxIKFz6CcmUwSvx7N
        YO5i5OBgE9CUuDC5FCQuIjCHUaJn93pWkG5mATuJGd9es4LUCAvYS3TtsgAJswioStw6foYN
        xOYVcJKYc/kZK8QyOYmb5zqZJzByLWBkWMUomVpQnJueW2xUYJSXWq5XnJhbXJqXrpecn7uJ
        Eej9bYe1+ncwPl4Sf4hRgINRiYd3her2GCHWxLLiytxDjBIczEoivI4pW2KEeFMSK6tSi/Lj
        i0pzUosPMUpzsCiJ8/LnH4sUEkhPLEnNTk0tSC2CyTJxcEo1MAYrZcWefKzbuS1rIjPPfJ2q
        dzb5xk/Yd8hnPU27aS8ozim44ObxKz7nFDeflkjn25Ahccr4wL77vxKaYrgWZP0v3XqgZM60
        B/lX5sgvatncdjZ6o09lJFv1t+ItuXw/eHZrqZVMUXE10Gi69K5ERemY+V/523frrl91yNy6
        7qOO941red4c3kosxRmJhlrMRcWJAOalJMD6AQAA
X-CMS-MailID: 20190417175347epcas2p41e4240ab83b46c9f07d237fc9494903a
CMS-TYPE: 102P
X-CMS-RootMailID: 20190417175347epcas2p41e4240ab83b46c9f07d237fc9494903a
References: <CGME20190417175347epcas2p41e4240ab83b46c9f07d237fc9494903a@epcas2p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

V4 series, towards extending write-hint/streams infrastucture so that file-systems
and other kernel-mode components can use write-hints which are separate from 
user-space ones. Also this introduces support for sending write-hint with 
Ext4/JBD2 journal.

Here is the changelog/history -

Changes since v3:                                                               
- Correction in grouping related changes into patches
- Rectification in commit text at places

Changes since v2:                                                               
- Introduce API in block layer so that drivers can register stream info. Added 
new limit in request queue for this purpose.
- Block layer does the conversion from write-hint to stream-id. 
- Any write-hint beyond registered limit turn to 0.
- New macro "WRITE_LIFE_KERN_MIN" can be used as base by kernel mode components.

Changes since v1:                                                               
- introduce four more hints for in-kernel use, as recommended by Dave chinner   
  & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
- remove mount-option to specify write-hint, as recommended by Jan kara &       
  Dave chinner. Rather, FS always sets write-hint for journal. This gets ignored
  if device does not support stream.                                            
- Removed code-redundancy for write_dirty_buffer (Jan kara's review comment) 

V3 patch:
https://marc.info/?l=linux-block&m=155384631909082&w=2

V2 patch:
https://patchwork.kernel.org/cover/10754405/

V1 patch:
https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2  

Kanchan Joshi (7):
  fs: introduce write-hint start point for in-kernel hints
  block: increase stream count for in-kernel use
  block: introduce API to register stream information with block-layer
  block: introduce write-hint to stream-id conversion
  nvme: register stream info with block layer
  fs: introduce APIs to enable passing write-hint with buffer-head
  fs/ext4,jbd2: add support for sending write-hint with journal

 block/blk-core.c            | 20 ++++++++++++++++++++
 block/blk-settings.c        | 12 ++++++++++++
 drivers/nvme/host/core.c    | 23 ++++++-----------------
 fs/buffer.c                 | 18 ++++++++++++++++--
 fs/ext4/ext4_jbd2.h         |  1 +
 fs/ext4/super.c             |  2 ++
 fs/jbd2/commit.c            | 11 +++++++----
 fs/jbd2/journal.c           |  3 ++-
 fs/jbd2/revoke.c            |  3 ++-
 include/linux/blkdev.h      |  7 ++++++-
 include/linux/buffer_head.h |  3 +++
 include/linux/fs.h          |  2 ++
 include/linux/jbd2.h        |  8 ++++++++
 13 files changed, 87 insertions(+), 26 deletions(-)

-- 
2.7.4

