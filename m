From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/5] e2fsprogs: add inline data
Date: Sun, 18 Dec 2011 22:44:39 +0800
Message-ID: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39686 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1LROlw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:41:52 -0500
Received: by iaeh11 with SMTP id h11so7090163iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 06:41:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Hi all,

This patchset lets e2fsprogs to support inline data.

PATCH 1/5: let mke2fs to support inline data.
PATCH 2/5: describe 'inline_data' option in man page.
PATCH 3/5: let debugfs to support inline data.
PATCH 4/5: let e2fsck to support inline data in pass1.
PATCH 5/5: let e2fsck to support inline data in pass2.

Regards,
Zheng
