From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [BUG][e2fsprogs] e2fsck: e2fsck reports ext3 message when checking
 ext4 filesystem
Date: Wed, 24 Dec 2008 11:14:30 +0800
Message-ID: <4951A916.706@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux-Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55522 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYLXDQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 22:16:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I use "e2fsck" to repair the damaged ext4 device.

The message was followings.

------
# ./e2fsck /dev/sdb3
e2fsck 1.41.3 (12-Oct-2008)
Superblock has an invalid ext3 journal (inode 8).
Clear<y>?
---

Why e2fsck tells me "ext3"? It looks the message was wrong
or e2fsck doesn't recognize ext4 correctly.

Thanks=EF=BC=81
Miao Xie

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
