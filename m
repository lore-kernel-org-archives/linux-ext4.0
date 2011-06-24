From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Do we really need parallel resizer?
Date: Fri, 24 Jun 2011 16:41:43 +0800
Message-ID: <BANLkTimYZR2tMABSjAO-pXtatgsz5x0zqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1FXIlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 04:41:45 -0400
Received: by pvg12 with SMTP id 12so1599624pvg.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jun 2011 01:41:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

I noticed that resize is protected by resize_lock.  Then parallel
resizer works.  However, I think there is no need to make parallel
resizer work.

I think we can use an atomic integer 'resize_flag' instead of
resize_lock,  resize_flag is set to 1 before the kernel does resizing
work,  while resize_flag is set to 0 after the kernel finishes
resizing work.  Resizing is allowed only if resize_flag is 0.  If
resize_flag is 1, kernel returns -EBUSY to userspace.

What about your opinion?

Yongqiang.

-- 
Best Wishes
Yongqiang Yang
