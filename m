From: Andy Lutomirski <luto@amacapital.net>
Subject: RAID stride 32751?
Date: Mon, 10 Dec 2012 17:58:32 -0800
Message-ID: <CALCETrUOUa7pUMxe4rZWCcOC_OU9HnkJWKMc=-kHVQ2sUaEppQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43223 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2LKB6x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2012 20:58:53 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so3131694vby.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2012 17:58:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have an old, ~1TB ext4 filesystem.  Performance sucks (although I
don't really think this is ext4's fault).  But tune2fs says this:

Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      960
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              32751

Is that 32751 a problem?  I'm not entirely sure what the raid
controller's stride is, but I doubt that it's 32751 bytes.

Thanks,
Andy
