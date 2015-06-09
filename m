From: Albino Biasutti Neto <bino@riseup.net>
Subject: Mount read-write EXT4
Date: Tue, 9 Jun 2015 15:07:20 -0300
Message-ID: <CAHAf8Wm1NOyF6dH+9_jo4u4+j=Z7m7WhQobYDXu-r8Jb+rL3-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:46373 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbbFISHn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 14:07:43 -0400
Received: from plantcutter.riseup.net (plantcutter-pn.riseup.net [10.0.1.121])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id 0978140A56
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 18:07:43 +0000 (UTC)
Received: by wgez8 with SMTP id z8so19064914wge.0
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2015 11:07:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

Error for mount, show dmesg:

XT4-fs (sda1): Filesystem with huge files cannot be mounted read-write
without CONFIG_LBDAF

$ make menuconfig, for enable:

Enable the block layer ---> Support for large (2TB+) block devices and files

But has compile kernel again.

With command not need compile.

# une2fs -O ^huge_file /dev/sda1

# fsck /dev/sda1


Can include as default on kernel ?


Albino
