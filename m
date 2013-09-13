From: Alexander Harrowell <a.harrowell@gmail.com>
Subject: ext4 recovery, the saga of 16777215 continues
Date: Fri, 13 Sep 2013 15:40:47 +0000
Message-ID: <CA+qGm=_vV3xv8ip6JfuW7hDo3ZgR5Bj4oA_1r0BPD33rAso0Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43482 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab3IMPks (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Sep 2013 11:40:48 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so1408342pdj.17
        for <linux-ext4@vger.kernel.org>; Fri, 13 Sep 2013 08:40:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, so after updating e2fsprogs and doing a bunch of hacking around, I
was eventually able to find the inode that returns hundreds of MB of
16777215 in the multiply-claimed blocks pass.

Dumping it out with debugfs, the output file reached 28 GB before the
device receiving ran out of space. I thought inodes were of defined
size?
