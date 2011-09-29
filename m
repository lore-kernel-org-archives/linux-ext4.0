From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC V2] ext4: implementation of delayed extent tree
Date: Thu, 29 Sep 2011 13:08:40 +0800
Message-ID: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, jeff.liu@oracle.com, achender@linux.vnet.ibm.com,
	adityakali@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33073 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1I2Gl1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:41:27 -0400
Received: by yib18 with SMTP id 18so248472yib.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 23:41:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all.

   This patch series implements delayed extent tree for ext4.

   Compared with previous patches, delayed extents are managed by
RB tree instead.

   For more infomation, please refer to the 3rd patch, the introduction
is put in fs/ext4/delayed_extents.c.

   Feedbacks are welcome.

Yongqiang.

[RFC PATCH V2 1/6] ext4: add two structures supporting delayed
[RFC PATCH V2 2/6] ext4: add a delayed extents tree in inode info
[RFC PATCH V2 3/6] ext4: add operations on delayed extent tree
[RFC PATCH V2 4/6] ext4: initialize delayed extent tree
[RFC PATCH V2 5/6] ext4: let ext4 maintian delayed extent trees
[RFC PATCH V2 6/6] ext4: reimplement fiemap on delayed extent tree

