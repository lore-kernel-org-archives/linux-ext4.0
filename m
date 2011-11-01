From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 0/8 bigalloc] ext4: change unit of extent's ee_len from block to cluster
Date: Tue,  1 Nov 2011 18:53:29 +0800
Message-ID: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53936 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1KAKxq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 06:53:46 -0400
Received: by qabj40 with SMTP id j40so5626898qab.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Nov 2011 03:53:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Hi,

This patch series change unit of ee_len (of extent) from "block" to "cluster".
Changing the unit of ee_len will reduce the space occupied by meta data.
