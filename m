From: Ramesh M <rameshandram@gmail.com>
Subject: Directio flags in dd command causes file corruption on ext4 filesystem
Date: Fri, 6 Feb 2015 00:46:57 +0530
Message-ID: <CABx-mUmNtkpUJCNRWBieu0B0vgwB5QyoLLmrbkKr6Qo0X7Zx8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50520 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbBETQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2015 14:16:58 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so8771950obb.13
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2015 11:16:57 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello All,

I am using linux 3.3.8 kernel on AP and trying to copy  5200  bytes
of data from AP to USB disk
( /dev/sda1 -contains ext4 ) using directio method .

For  example
  mount  /dev/sda1 /mnt/usb-ext4/

   dd if=inptu.data  of=/mnt/usb-ext4/output.data bs=4096
conv=notrunc oflag=append,direct

the input.data  file contains know pattern for example 0xaa55. and
after writing this file from AP to USB disk, randomly  i observed
that  the output.data  file was corrupted (instead of 0xaa55, zero is
written in the middle of the output file ) .

is there any patches already available to fix this issue ?

Thanks in advance for your help.

Regards
Ramesh
