From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC] implementation of delayed extent list
Date: Tue, 30 Aug 2011 17:00:16 +0800
Message-ID: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, adityakali@google.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38263 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1H3Jnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 05:43:37 -0400
Received: by pzk37 with SMTP id 37so10017235pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 02:43:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

  This patch series implements delayed extent list, more analysis is
  in the 3rd patch.

  Any feedbacks or suggestions are welcome.

  Yongqiang.

[RFC PATCH 1/5] ext4: add two structures delayed extent list nees
[RFC PATCH 2/5] ext4: add a delayed extents list in inode
[RFC PATCH 3/5] ext4: add operations on delayed extent tree
[RFC PATCH 4/5] ext4: let ext4 maintian delayed extent lists
[RFC PATCH 5/5] ext4: reimplement fiemap on delayed extent list

