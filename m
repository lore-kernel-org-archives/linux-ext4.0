Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C72C282E1
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECAEC2084B
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="piWEIq1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfDYLXx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:23:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33216 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDYLXx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:23:53 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190425112348epoutp04bd689f55863d0331c51df4b67f7c2194~Ys9v3MUWi0936909369epoutp04c;
        Thu, 25 Apr 2019 11:23:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190425112348epoutp04bd689f55863d0331c51df4b67f7c2194~Ys9v3MUWi0936909369epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191428;
        bh=Qb44Fw5D9COaD1U8JoeC5CdpDtMwZZct+PLZkv9jaZM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=piWEIq1JH/w+4vWjtvkXWfWAFjmXlIoHNKoUx5+jueZ/G9KWy1ML/HuQiHpbPzH43
         XTcQsvkWHZYeN5sBBge2Hnz19z8+xItHJ29nH5dgqC9U5m6rs/JhMwc4ifMZ8dzYNg
         kKEAH9c8V/kdnhaDqdT7UlJi6HZ7y1rkRDbjFTPs=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190425112348epcas2p20fb94b4c3711c4a4d59f90ae237be6f9~Ys9vWA0-G2452224522epcas2p2w;
        Thu, 25 Apr 2019 11:23:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.B9.04206.3C891CC5; Thu, 25 Apr 2019 20:23:47 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190425112347epcas2p1f7be48b8f0d2203252b8c9dd510c1b61~Ys9urcw5x2606226062epcas2p1P;
        Thu, 25 Apr 2019 11:23:47 +0000 (GMT)
X-AuditID: b6c32a47-14bff7000000106e-c7-5cc198c37f76
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 46.4D.03620.3C891CC5; Thu, 25 Apr
        2019 20:23:47 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:23:47 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 0/7] Extend write-hint framework, and add write-hint for
 Ext4 journal
Date:   Thu, 25 Apr 2019 16:49:55 +0530
Message-id: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdljTVPfwjIMxBm+mW1r8nj6F1eLo/7ds
        FntvaVvMnHeHzWLP3pMsFpd3zWGzmL/sKbvFlSmLmB04PDYvqffo27KK0ePzJrkA5igum5TU
        nMyy1CJ9uwSujEdn37EU/BCrmLH8BFMDY7tQFyMHh4SAicSM89FdjFwcQgI7GCX+r3vNCuF8
        Z5SYfWwzI0xR+1l+iPgGRonbkx6zQDjTmSSWrvkCVsQmoClxYXIpSFxEYA6jxLJ905i7GDk5
        mAVCJFY8WcUCYgsLREmsnf6EEcRmEVCV+HzkBRtIL6+Ak8Tlo14gYQkBOYmb5zqZIeyXrBK7
        b0hC2C4Sm85eYIOwpSWerdrICGEXS/y6c5QZZK+EQAejxPWGmSwQCXuJi3v+MkHcwCfRcfgv
        O8QzvBIdbUIQJR4SD99C/CgkECtx+brUBEbxBYwMqxjFUguKc9NTi40KjPWKE3OLS/PS9ZLz
        czcxguNGy30H47ZzPocYBTgYlXh4FSIPxAixJpYVV+YeYpTgYFYS4VU3PRgjxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPeh9NxoIYH0xJLU7NTUgtQimCwTB6dUA2PBlI2nllyskAo4d8ZNZ7O3
        eNXz5plbN/07uk7y8UXBhWIuDO5vArPsjD+/nX1l0/lOgU97JFSiPl3or9tit3pX0dnXLxN1
        Pziu8/377MyS3XWxgXFnmo78ZZ3e4rz46MNNl6YVKtR0RwQeOPBbeZ/HjR8ZK9uf6cz9Mo/d
        nEutqu3kI484Z8UDSizFGYmGWsxFxYkANG0e+pcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jQd3DMw7GGExdyW/xe/oUVouj/9+y
        Wey9pW0xc94dNos9e0+yWFzeNYfNYv6yp+wWV6YsYnbg8Ni8pN6jb8sqRo/Pm+QCmKO4bFJS
        czLLUov07RK4Mh6dfcdS8EOsYsbyE0wNjO1CXYwcHBICJhLtZ/m7GLk4hATWMUoc+N7KBuHM
        ZJJ4dmsRG0gRm4CmxIXJpSBxEYE5jBI9u9ezdjFycjALhEjMevaYDcQWFoiS6Hw9jQnEZhFQ
        lfh85AVYL6+Ak8Tlo14gYQkBOYmb5zqZJzByLWBkWMUomVpQnJueW2xUYJSXWq5XnJhbXJqX
        rpecn7uJERgE2w5r9e9gfLwk/hCjAAejEg+vQuSBGCHWxLLiytxDjBIczEoivOqmB2OEeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ8/LnH4sUEkhPLEnNTk0tSC2CyTJxcEo1MCYVtxgUKO7vOpZX
        6/b26USJyY9yvVI9O99InNzo+v2Ox/5fbae/53aevnfVyCFlliTnH0X+Ln05wyfXPx4U4Mru
        fc1XL+Fx3WLTory7ZTGm4v/9fOY6KC/Mdel6HOLf87z0wJ869rd7s+6vfvk47aLv6q41LhEq
        POEsH79Xx7zb9W0r8/xVEUosxRmJhlrMRcWJAGM3ON/+AQAA
X-CMS-MailID: 20190425112347epcas2p1f7be48b8f0d2203252b8c9dd510c1b61
CMS-TYPE: 102P
X-CMS-RootMailID: 20190425112347epcas2p1f7be48b8f0d2203252b8c9dd510c1b61
References: <CGME20190425112347epcas2p1f7be48b8f0d2203252b8c9dd510c1b61@epcas2p1.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

V5 series, towards extending write-hint/streams infrastructure for
kernel-components, and adding support for sending write-hint with Ext4/JBD2 journal.

Here is the history/changelog -

Changes since v4:
- Removed write-hint field from request. bi_write_hint in bio is used for
  merging checks now.
- Modified write-hint-to-stream conversion logic. Now, kernel hints are mapped
  to upper range of stream-ids, while user-hints continue to remain mapped to
  lower range of stream-ids.

Changes since v3:
- Correction in grouping related changes into patches
- Rectification in commit text at places

Changes since v2:
- Introduce API in block layer so that drivers can register stream info. Added
  new limit in request queue for this purpose.
- Block layer does the conversion from write-hint to stream-id.
- Stream feature is not disabled anymore if device reports less streams than
  a particular number (which was set as 4 earlier).
- Any write-hint beyond reported stream-count turn to 0.
- New macro "WRITE_LIFE_KERN_MIN" can be used as base by kernel mode components.

Changes since v1:
- introduce four more hints for in-kernel use, as recommended by Dave chinner
  & Jens axboe. This isolates kernel-mode hints from user-mode ones.
- remove mount-option to specify write-hint, as recommended by Jan kara &
  Dave chinner. Rather, FS always sets write-hint for journal. This gets ignored
  if device does not support stream.
- Removed code-redundancy for write_dirty_buffer (Jan kara's review comment)

V4 patch:
https://lkml.org/lkml/2019/4/17/870

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

 block/blk-core.c            | 29 ++++++++++++++++++++++++++++-
 block/blk-merge.c           |  4 ++--
 block/blk-settings.c        | 12 ++++++++++++
 drivers/nvme/host/core.c    | 23 ++++++-----------------
 fs/buffer.c                 | 18 ++++++++++++++++--
 fs/ext4/ext4_jbd2.h         |  1 +
 fs/ext4/super.c             |  2 ++
 fs/jbd2/commit.c            | 11 +++++++----
 fs/jbd2/journal.c           |  3 ++-
 fs/jbd2/revoke.c            |  3 ++-
 include/linux/blkdev.h      |  8 ++++++--
 include/linux/buffer_head.h |  3 +++
 include/linux/fs.h          |  2 ++
 include/linux/jbd2.h        |  8 ++++++++
 14 files changed, 97 insertions(+), 30 deletions(-)

-- 
2.7.4

