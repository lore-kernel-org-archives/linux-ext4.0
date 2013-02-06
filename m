From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 1/3] Ext2: remove the overhead check about sb in the function
 ext2_new_blocks
Date: Wed, 06 Feb 2013 12:22:47 -0800
Message-ID: <5112BB97.8040206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:51664 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab3BFEWj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 23:22:39 -0500
Received: by mail-ia0-f172.google.com with SMTP id u8so1068089iag.3
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 20:22:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

It can be guranteed that inode->i_sb should not be null in vfs.
So here the check about it is overhead.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---

sorry about wrong format patch=A3=AC i will resend it later.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
