From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 0/5 bigalloc] e2fsprogs: change unit of extent's ee_block and ee_len from block to cluster for bigalloc
Date: Fri, 18 Nov 2011 18:55:25 +0800
Message-ID: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1KRKzk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:40 -0500
Received: by iage36 with SMTP id e36so3440789iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Hi,

After the kernel patch series which change ee_block and ee_len (of extent) 's unit from "block" to "cluster",
We need e2fsprogs to support this too.
