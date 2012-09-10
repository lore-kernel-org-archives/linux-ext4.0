From: Terry <td3201@gmail.com>
Subject: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Sun, 9 Sep 2012 21:34:10 -0500
Message-ID: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43768 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab2IJCeM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 22:34:12 -0400
Received: by lagy9 with SMTP id y9so798608lag.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 19:34:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

As the subject says, we have a 15 TB fsck drive that won't mount with
these errors:

Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): ext4_check_descriptors:
Inode bitmap for group 3200 not in group (block 4161027887)!
Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): group descriptors corrupted!


We did a proactive fsck on Tuesday of last week because it was
starting to give filesystem errors. It ran through and mounted fine.

The filesystem lives on an equallogic SAN spread across 36 drives.
Could this be something with the physical layer or is it not abnormal
to have to run multiple rounds of fsck to fully fix an issue?

Thanks!
