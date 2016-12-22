From: Dan Arena <ddan39@gmail.com>
Subject: Why is 64bit option always on by default now?
Date: Thu, 22 Dec 2016 13:59:55 -0500
Message-ID: <CAKnMEmEd0hdS_ajNhsr9t9GvCZXG4MD6-K-tsx5YKRX9gsQDmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:33531 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934398AbcLVS75 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Dec 2016 13:59:57 -0500
Received: by mail-it0-f49.google.com with SMTP id c20so39034611itb.0
        for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2016 10:59:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I just spent a while troubleshooting a system that wouldn't boot after
reformatting an ext4 filesystem. I finally figured out that it was the
ext4 64bit feature which caused the issue because the board's
bootloader doesn't support it. Tracking why it occurred when doing
mkfs on one system (fedora 23) vs another (fedora 25) I noticed that
fedora 25 now has the 64bit option in the features list for ext4 in
/etc/mke2fs.conf.

Why was it changed from "auto_64-bit_support" which only added the
64bit option if needed when creating a filesystem larger than 16TB, to
now being always on, even when creating a small filesystem?

I was trying to think of why this would be changed from the "auto
64bit" setting, and it came to mind that it may be useful for when you
later want to grow a filesystem to over 16TB. It looks like you can
now add the 64bit option using resize2fs though, so that point isn't
as important. Maybe this wasn't possible before, so it was the better
option. Now that it can be added with resize2fs, do you think it
should be changed back to "auto 64bit"? I realize having to add the
64bit option with resize2fs may prevent live resizing to larger than
16TB, but I don't think that scenario will be very common, so the
extra work of having to do the offline resize2fs isn't a big deal.

While doing some research I read that it also broke compatibility with
a few other things. I am not sure what the best solution is, I was
just surprised how this compatibility-breaking change was made with as
far as I know not much warning to the community or when running the
command or something.

Thanks,
Dan
