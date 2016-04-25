From: Barry Kauler <bkauler@gmail.com>
Subject: f.s. corruption ext3, kernel 4.4.8
Date: Mon, 25 Apr 2016 09:46:19 +0800
Message-ID: <CABWT5yh98_f5=Y0k7_ELHM=fn35s0Eb5D5kmDCSsFMikgmscnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:33648 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbcDYBqU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2016 21:46:20 -0400
Received: by mail-yw0-f182.google.com with SMTP id t10so182695272ywa.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2016 18:46:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I sent this direct to Greg KH yesterday morning. 24 hours later got an
automated reply to send my email to one of the lists.

I'm a user, not a kernel developer, gotta post this somewhere.

I reckon this is urgent.
I have rolled back from 4.4.8 to 4.4.7, have used heavily for 24 hours
since then,
no problem. So, it's the kernel, not my laptop.

Here is my msg to Greg:
-------------------------
Greg,
I thought that I had better alert you to this, just in case.

I posted to my blog, quoting it here:

--------------------
As I reported last night, I compiled the 4.4.8 kernel

This morning, powered-up my laptop, clicked on "sda5", my main working
partition, about 300GB with ext3 filesystem.

I edited 'quicksetup', to fix the firewall checkbox, then went to save
and got an I/O error.

I found that sda5 has been mounted "ro". I unmounted it,
clicked again to mount it, this time it mounted "rw", but looking at
the filesystem with ROX-Filer, I find corruption, some directories have
become I/O errors and replaced by triangle-with-exclamation-mark
icons.

I rebooted, with Quirky 8.0 and 4.4.7 kernel. Mounted sda5 and now the
filesystem looks OK in ROX-Filer. Oh dear.

I unmounted sda5, started "fsck.ext3 -p /dev/sda5", which reported
errors and check is forced. Afterward, filesystem looks ok.

Hard disk or RAM failure, maybe. But it is quite a coincidence that I
compiled 4.4.8 last night. Then, going back to 4.4.7, my filesystem
looks OK again.
-----------------------

Of course, when it mounted "ro" the first time, that should have set
off alarm bells and I should probably have backed up immediately.

It may just be my laptop drive or RAM, but I thought it wise to alert
you, just in case 4.4.8 is the cause. It could be that there is
something with the ext3 driver or elsewhere that is causing the
corruption.

Back on 4.4.7, I seem to be OK. Right now, doing a backup of the partition.

Regards,
Barry Kauler
