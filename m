From: "Ki'Sak" <kisak42@gmail.com>
Subject: Bulk block to filename lookups on an incomplete dd copy
Date: Thu, 20 Aug 2015 23:36:30 -0400
Message-ID: <CAL=yMgXojd52osdWNY2dp-WNsghFogZD-SBRU+JLj3N9gNvJgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34482 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbHUDgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2015 23:36:31 -0400
Received: by wicne3 with SMTP id ne3so8558105wic.1
        for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2015 20:36:30 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a followup, it looks like I'm getting 21 lines of "icheck: Corrupt
extent header while calling ext2fs_block_iterate" per empty block, and
19 lines of it per block with an inode.
