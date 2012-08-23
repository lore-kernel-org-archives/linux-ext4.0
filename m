From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Dump file inode information from ext2/3 partition
Date: Thu, 23 Aug 2012 19:43:29 +0530
Message-ID: <CAD6i1fJF5wcX2dj2P8mUR4J5Qz3x58CiSfzubYoy0b1ZcRYcRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59291 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2HWONv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2012 10:13:51 -0400
Received: by eeil10 with SMTP id l10so295963eei.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Aug 2012 07:13:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We wrote a small tool to dump file inode information from ext2/3
partition as an assignment related to learning about file systems.

https://github.com/prashants/tools/tree/master/ext
https://github.com/prashants/tools/blob/master/ext/ext3dump.c

I am not sure if there is any future use for it other than for
learning purposes.

Regards.
