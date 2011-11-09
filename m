From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 0/9 bigalloc] ext4: change unit of extent's ee_block and ee_len from block to cluster
Date: Wed,  9 Nov 2011 19:16:59 +0800
Message-ID: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46160 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1KILRY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:24 -0500
Received: by ggnb2 with SMTP id b2so1603917ggn.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Hi,

This patch series change ee_block and ee_len (of extent) 's unit from "block" to "cluster",
since it could reduce the space occupied by meta data.

This patch series should be used after Ted's bigalloc-patchs and it now can't support:
1. delay allocation
2. 1k/2k blocksize

