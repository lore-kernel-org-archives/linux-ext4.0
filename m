From: Sayan Ghosh <sgdgp.2014@gmail.com>
Subject: [QUESTION] Getting block bitmap
Date: Mon, 18 Dec 2017 23:13:39 +0530
Message-ID: <CAExFE6=Oj27M-6x++VGC6DNhao539CtjiPjmGgfk6LDRRVzufA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:32784 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936782AbdLRRoV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Dec 2017 12:44:21 -0500
Received: by mail-it0-f41.google.com with SMTP id o130so5920286itg.0
        for <linux-ext4@vger.kernel.org>; Mon, 18 Dec 2017 09:44:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

bh = ext4_read_block_bitmap(sb,block_group);

This function return the buffer head for the block/page with the block bitmap

char *block_bmap = bh->b_data;

Doing this does not give the block bitmap string

What is the process to get the block bitmap in string or array form?

Regards,
Sayan
