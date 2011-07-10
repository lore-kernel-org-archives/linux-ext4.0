From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Why can not we trust free blocks count in BLOCK_UNINIT group descriptor
Date: Sun, 10 Jul 2011 11:19:06 +0800
Message-ID: <CAGBYx2avvn9t0AUST1zVW1Yw9Bd7xntOCHOj0HjUMBNxEXLV5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63285 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1GJDTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2011 23:19:07 -0400
Received: by pzk9 with SMTP id 9so2214798pzk.19
        for <linux-ext4@vger.kernel.org>; Sat, 09 Jul 2011 20:19:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Now ext4 gets free blocks count directly from a group descriptor
without BLOCK_UNINIT, however calculates free blocks count for a group
descriptor with BLOCK_UNINIT via ext4_init_block_bitmap().   The group
descriptors with BLOCK_UNINIT have group check sums.   Now comes the
question,  why do not we get it directly from group descriptor?

Yongqiang.
