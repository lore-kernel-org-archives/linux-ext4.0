Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CD4C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E7921773
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rzIViYxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfC2H5n (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:57:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54610 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728937AbfC2H5m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:57:42 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190329075738epoutp04cd1edf13242593745dd3221f7892eeb2~QXvCN6j7i1708117081epoutp04e;
        Fri, 29 Mar 2019 07:57:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190329075738epoutp04cd1edf13242593745dd3221f7892eeb2~QXvCN6j7i1708117081epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846258;
        bh=v0Q6ayUZE5qT6eA3Vyc1UBCx/oaxtVit/tVtoFnGuq4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=rzIViYxQoTFxJMaO/fRY6Pc9zKub3KDdidC8XsovRVIXcb/lBFACaFFeUgbyuTzAr
         iNug1Gt4tGjpOCLPiCaAQQK0MPNKrHknQsjTYZkRPJS3F++6CbpnZKjHxzdKHOGsi6
         Wwz86Rjj0f9Pz2myWCsunbjzh5y9SxcoHcXjF2gU=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190329075738epcas1p18686183ad2d4150dc37d0094f1317cd7~QXvB-sl4n2148321483epcas1p1E;
        Fri, 29 Mar 2019 07:57:38 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.45.04139.2FFCD9C5; Fri, 29 Mar 2019 16:57:38 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190329075737epcas1p4f32cad26279c1146982a6c91b3378eab~QXvBf-vTM2558625586epcas1p4o;
        Fri, 29 Mar 2019 07:57:37 +0000 (GMT)
X-AuditID: b6c32a35-deaec9c00000102b-16-5c9dcff2e99e
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.7F.03598.1FFCD9C5; Fri, 29 Mar 2019 16:57:37 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:57:37 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 0/7] Extend write-hint for in-kernel use
Date:   Fri, 29 Mar 2019 13:23:45 +0530
Message-id: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCmru6n83NjDJ7flrL4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyjjw8TJbQaNIxbq5xxgbGLfzdTFyckgI
        mEicff+CqYuRi0NIYAejxL6Z35ghnO+MEmdO9jLDVM29fw2qajejxJzDU1ghnOlMEq8nz2Xs
        YuTgYBPQlLgwuRQkLiIwh1Fi2b5pYN3MAuUSf6dcZQSxhQWsJV7u3MIKYrMIqEp83tkCFucV
        cJK43NfBBLFNTuLmuU6wMyQEetgktk54wwiRcJG4d24bE8gyCQFpiUtHbSHCxRK/7hyFqu9g
        lLjeMJMFImEvcXHPXyaII/gk3n3tYYXo5ZXoaBOCKPGQ+LpxEzuILSQQK3F34n7mCYziCxgZ
        VjGKpRYU56anFhsWGOoVJ+YWl+al6yXn525iBMeZlukOxinnfA4xCnAwKvHwztg5J0aINbGs
        uDL3EKMEB7OSCG/gubkxQrwpiZVVqUX58UWlOanFhxilOViUxHnXOzjHCAmkJ5akZqemFqQW
        wWSZODilGhin9hX3rU6zkPO/UVMVyve93WPWX2ZJ5omqFT828e7c5Zlf/eRe/3XOJRO7ZXc6
        n53w0/zznS+K2t0iNWf18m8tCFb/p9x4J0rjw4pby4+4GKrnbKlfXba3UOcdb+Bz3bmPvm+w
        4V9jdXrW3I8q083NG1/8YVm1YrZvc3ZBnMAxmw3NGarB51uUWIozEg21mIuKEwFSBUOMrwIA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd2P5+fGGFxYYW7xe/oUVov/e46x
        WRz9/5bN4vzbw0wWe29pW8ycd4fNYs/ekywWl3fNYbOYv+wpu8WVKYuYHbg8Jja/Y/fYOesu
        u8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlXHg42W2gkaRinVzjzE2MG7n62Lk5JAQ
        MJGYe/8aE4gtJLCTUeJnf0QXIxeQPZNJYvHqH8xdjBwcbAKaEhcml4LERQTmMEr07F7PChJn
        FiiXmLKJE6RXWMBa4uXOLawgNouAqsTnnS2MIDavgJPE5b4OJohdchI3z3UyT2DkWsDIsIpR
        MrWgODc9t9iowDAvtVyvODG3uDQvXS85P3cTIzBYth3W6tvBeH9J/CFGAQ5GJR7eGTvnxAix
        JpYVV+YeYpTgYFYS4Q08NzdGiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/tvGORQgLpiSWp2amp
        BalFMFkmDk6pBsbZ1975MvD4pdV/MPpT1vmt56iuVJxly6fjFvuC96wNvs6YzGv6a/JBPgeb
        g+eP7t9x1CrW0zPoz4fif61ShxSUwv+LP9hsvCXtwJcn3/umam3+z6SyZIWiRfdUgZYJi4XX
        mvZf1rjMd6CN1W7z8wTN837fVjWlCa78xhDbIhR3vNLgvt6lmVeVWIozEg21mIuKEwHFoTbP
        EgIAAA==
X-CMS-MailID: 20190329075737epcas1p4f32cad26279c1146982a6c91b3378eab
CMS-TYPE: 101P
X-CMS-RootMailID: 20190329075737epcas1p4f32cad26279c1146982a6c91b3378eab
References: <CGME20190329075737epcas1p4f32cad26279c1146982a6c91b3378eab@epcas1p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Towards extending write-hints/streams infrastucture so that file-systems
and other kernel-mode components can use exclusive hints. This patchset also
modifies Ext4/JBD2 to use new in-kernel, write-hint with journal. 

Here is the history and changelog -

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

V2 patch:
https://patchwork.kernel.org/cover/10754405/
V1 patch:
https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2  

Note: I am sorry about the fact this patchset is against 5.0.0-rc4, rather than 
against linux-next.

Kanchan Joshi (7):
  block: extend stream count for in-kernel use
  block: introduce API to register stream information with block layer
  block: add write-hint to stream-id conversion
  nvme: register stream info with block layer
  fs: introduce APIs to enable sending write-hint with buffer-head
  fs: introduce write-hint start point for in-kernel hints
  fs/ext4,jbd2: add support for passing write-hint with journal

 block/blk-core.c            | 20 ++++++++++++++++++++
 block/blk-settings.c        | 12 ++++++++++++
 drivers/nvme/host/core.c    | 19 ++++++-------------
 fs/buffer.c                 | 18 ++++++++++++++++--
 fs/ext4/ext4_jbd2.h         |  1 +
 fs/ext4/super.c             |  2 ++
 fs/jbd2/commit.c            | 11 +++++++----
 fs/jbd2/journal.c           |  3 ++-
 fs/jbd2/revoke.c            |  3 ++-
 include/linux/blkdev.h      |  9 +++++++--
 include/linux/buffer_head.h |  3 +++
 include/linux/fs.h          |  2 ++
 include/linux/jbd2.h        |  8 ++++++++
 13 files changed, 88 insertions(+), 23 deletions(-)

-- 
2.7.4

