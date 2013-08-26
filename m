From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Block allocation in EXT4
Date: Mon, 26 Aug 2013 21:25:19 +0530
Message-ID: <CAEUQceiEUQOHf8ujjbJF2Q3HSvcqo7r=KOfgoCkFGB_tE6EdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51508 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab3HZPzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Aug 2013 11:55:20 -0400
Received: by mail-qe0-f45.google.com with SMTP id 8so1169904qea.18
        for <linux-ext4@vger.kernel.org>; Mon, 26 Aug 2013 08:55:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 In EXT4 it seems that both direct/indirect and extent tree based
block allocation is used. I used debugfs and it seems that the root
inode uses the direct/indirect block allocation. The other files and
direcyories used extent based allocation.

Do all the EXT4 reserved inode (0 -11) use the direct/indirect
allocation scheme?
