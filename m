Return-Path: <SRS0=KVWg=4H=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496AFC34022
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Feb 2020 03:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23E862176D
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Feb 2020 03:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Bce/wDAM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBSDKi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Feb 2020 22:10:38 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:28837 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgBSDKi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Feb 2020 22:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582081837; x=1613617837;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=/IeOXZFEImLP23fnQIbZ0isIjjVE+31UmVP9q10URvk=;
  b=Bce/wDAM13QLuXxwoaINdIxsMgezZ5C1LiI/iyVzbYVLF3ftZ9vf8uho
   bjYCTM819ylCfvbnn9e5B/jVwO0MYjvVv27Nm9opD2hGnanbNTdi+c9q8
   1adyBRZBltReDeolI8sRZPqBfZE9sksQURxyV0twtFcab+ri55HhjqWnp
   E=;
IronPort-SDR: sucj/9iHjZJBzWWs/wMcbdITLbv6Of6fOCy2WfcEsOZjDUeQOIs0DRaNvr5FCCVZgbau3rb1Ap
 jgLI6Rq5ogGg==
X-IronPort-AV: E=Sophos;i="5.70,458,1574121600"; 
   d="scan'208";a="16986530"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Feb 2020 03:10:24 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 462FCA2BCC;
        Wed, 19 Feb 2020 03:10:22 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:22 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.235) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:22 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <sblbir@amazon.com>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH 0/3] ext4: Fix potential races when performing online resizing
Date:   Tue, 18 Feb 2020 19:08:48 -0800
Message-ID: <20200219030851.2678-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.235]
X-ClientProxiedBy: EX13D33UWB004.ant.amazon.com (10.43.161.225) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch series fixes 2 additional races between array resizing and
array element access when performing online resizing of the arrays
s_group_info and s_flex_groups.

These patches apply on top of the patch:
[PATCH RFC] ext4: fix potential race between online resizing and write operations

The macro sbi_array_rcu_deref() is introduced for simplicity but can be
removed if undesired.

Tested by performing the following:
truncate -s 100G /tmp/foo
sudo bash -c 'while true; do dd if=/dev/zero of=/mnt/xxx bs=1M count=1; sync; \
rm /mnt/xxx; done' &
while true; do mkfs.ext4 -b 1024 -E resize=26213883 /tmp/foo 2096635 -F; \
sudo mount -o loop /tmp/foo /mnt; sudo resize2fs /dev/loop0 26213883; \
sudo umount /mnt; done

Suraj Jitindar Singh (3):
  ext4: introduce macro sbi_array_rcu_deref() to access rcu protected
    fields
  ext4: fix potential race between s_group_info online resizing and
    access
  ext4: fix potential race between s_flex_groups online resizing and
    access

 fs/ext4/balloc.c  | 11 +++++-----
 fs/ext4/ext4.h    | 25 +++++++++++++++++----
 fs/ext4/ialloc.c  | 21 +++++++++++-------
 fs/ext4/mballoc.c | 19 ++++++++++------
 fs/ext4/resize.c  |  4 ++--
 fs/ext4/super.c   | 56 ++++++++++++++++++++++++++++++++---------------
 6 files changed, 91 insertions(+), 45 deletions(-)

-- 
2.17.1

