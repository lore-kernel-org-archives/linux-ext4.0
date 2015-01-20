From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Snapshot cannot be deleted
Date: Tue, 20 Jan 2015 13:28:04 +0100
Message-ID: <CAKVY-+9cjRKfXFVVEamtNVLaWE1+jc44M4kyrJOOk915v2fxtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36511 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbATM2F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jan 2015 07:28:05 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so8413815igb.0
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jan 2015 04:28:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Due to the known (and fixed) bug in kernel 3.17.0 one of my btrfs
volume suffers from unreadable and - even worse - uneraseable
snapshots. Whenever such a snapshot is accessed there is "parent
transid verify failed" in dmesg.
Is there any way to delete these snapshots?

Thanks,
Andreas
