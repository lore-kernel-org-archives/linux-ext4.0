From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 0/9 v2 bigalloc] ext4: change unit of extent's ee_block and ee_len from block to cluster for bigalloc
Date: Fri, 18 Nov 2011 18:42:55 +0800
Message-ID: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1KRKnO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:43:14 -0500
Received: by yenq3 with SMTP id q3so2287556yen.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:43:13 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Hi,

This patch series change ee_block and ee_len (of extent) 's unit from "block" to "cluster",
since it could reduce the space occupied by meta data.

This patch series should be used after Ted's bigalloc-patchs and it now can't support:
1. delay allocation
2. 1k/2k blocksize

