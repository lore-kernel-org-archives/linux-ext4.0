From: "kaefert@gmail.com" <kaefert@gmail.com>
Subject: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Wed, 7 Nov 2012 09:23:22 +0100
Message-ID: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54850 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2KGIXo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 03:23:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so737088eek.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Nov 2012 00:23:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

I've got this problem with an ext4 filesystem on an external usb disk
of mine, I've documented the problem (and my approaches for solving
it) here:
http://serverfault.com/questions/446074/e2fsck-extremly-slow-although-enough-memory-exists

I started gparted and with it e2fsck is around 2012-11-04_2200 and its
2012-11-07_0923 right now (CET).
It used up nearly 57 hours of cpu time since then, and I would like to
find out if and when it will finish.
Can somebody tell me if and how I could get this information?

Thanks for developing this great filesystem, and thanks for helping me
out in my hour[s ;)] of need.

Kind Regards,

Thomas K.
