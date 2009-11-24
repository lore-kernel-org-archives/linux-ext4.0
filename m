From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a suspected race bug at ext3_xattr_block_set()
Date: Tue, 24 Nov 2009 20:27:41 +0900
Message-ID: <2014bcab0911240327r68afb4a3r6e9cf238ce0df532@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:33727 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbZKXL1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2009 06:27:35 -0500
Received: by pxi10 with SMTP id 10so4856715pxi.33
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2009 03:27:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.
I am reporting a suspected data race bug from ext3/xattr.c in Linux 2.6.31.

In ext3_xattr_block_set(), it accesses bs->bh->b_data
while it does not hold lock_buffer(bs->bh).

However, there is no lock_buffer(bs->bh) and unlock_buffer(bs->bh)
for guarding the access (at line 794).

Due to the lack of synchronization, it seems that data race on
bs->bh->b_data might be possible.

Please examine the code to check whether it is problematic or not.
Thank you.

Sincerely
Shin Hong
