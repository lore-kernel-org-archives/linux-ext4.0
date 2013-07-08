From: Michael <mike@draftx.net>
Subject: EXT4 Larger Than 16TB
Date: Mon, 8 Jul 2013 16:32:50 -0500
Message-ID: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32959 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GHVcv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 17:32:51 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so4493404pdj.31
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jul 2013 14:32:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a currently 15TB FS that I want to expand to 18TB.
Unfortunately EXT4 e2fsprogs has an issue that stops you from being
able to do this:

sudo resize2fs /dev/md0
resize2fs 1.42.5 (29-Jul-2012)
resize2fs: New size too large to be expressed in 32 bits

It seems to me, reading the change logs, that this only supported if
you created your FS with 64 bit specified. There seems to have been a
patch last year that added support for changing 32->64bit, but I had a
hard time finding/tracking that.

What is the state of expanding an ext4 FS larger than 16tb?

I am not subscribed, please include me in reply.

Thank you!
