From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: confused by delayed allocation and ordered journal
Date: Sat, 25 Dec 2010 21:15:28 +0800
Message-ID: <AANLkTi=2S3JsAOP290_1ASMNGKMFZK+Srt4v5Qs474dB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0LYNPa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Dec 2010 08:15:30 -0500
Received: by eye27 with SMTP id 27so3501014eye.19
        for <linux-ext4@vger.kernel.org>; Sat, 25 Dec 2010 05:15:29 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I found that if a block'allocation is delayed, and is not allocated
when journal flushes it, then journal just redirties it and return in
journal_submit_data_buffers.

If I understand right, how to guarantee that the journal mode is ordered?

Thanks,
Yongqiang.
-- 
Best Wishes
Yongqiang Yang
