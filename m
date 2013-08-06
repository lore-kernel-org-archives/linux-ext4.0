From: jon ernst <jonernst07@gmail.com>
Subject: [ext4] found a minor typo in ext4/ialloc.c
Date: Tue, 6 Aug 2013 01:23:02 +0000
Message-ID: <CAGW2f1EWVTFxtowqBRdx5OmbkRvYvRCE_A6ep9kGmxoZWYb-1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38357 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3HFBXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 21:23:03 -0400
Received: by mail-oa0-f47.google.com with SMTP id g12so7690689oah.6
        for <linux-ext4@vger.kernel.org>; Mon, 05 Aug 2013 18:23:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Found a minor typo on "dev" branch. commit 4a8603 "ext4: avoid reusing
recently deleted inodes in no journal mode"

line 792 goto net_inode; should be goto next_ino;
it prevents compiling.

Best,
P.S. thanks for answering my question regarding debug tools.

Jon
