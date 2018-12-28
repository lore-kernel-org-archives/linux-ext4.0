Return-Path: <SRS0=cNy7=PF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37081 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbeL1BC3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2018 20:02:29 -0500
Received: by mail-lf1-f65.google.com with SMTP id y11so13657221lfj.4
        for <linux-ext4@vger.kernel.org>; Thu, 27 Dec 2018 17:02:27 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id 185-v6sm5699794ljj.49.2018.12.27.17.02.25
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Dec 2018 17:02:25 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id x85-v6so17539012ljb.2
        for <linux-ext4@vger.kernel.org>; Thu, 27 Dec 2018 17:02:25 -0800 (PST)
MIME-Version: 1.0
References: <20181220135252.GB15045@quack2.suse.cz>
In-Reply-To: <20181220135252.GB15045@quack2.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Dec 2018 17:02:09 -0800
Message-ID: <CAHk-=wgagiSgqXu_53p+Dx-aGfU4w6z1xLzqZTqpbKvg=7ahhg@mail.gmail.com>
Subject: Re: [GIT PULL] Ext2, udf, and quota changes for v4.21-rc1
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 20, 2018 at 5:52 AM Jan Kara <jack@suse.cz> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_4.21-rc1
>
> to get some ext2 cleanups, a fix for UDF crash on corrupted media, and one
> quota locking fix.
>
> Top of the tree is 2aad26fa0a3d.

This time the tag name was correct, but once again the "Top of tree is
2aad26fa0a3d" was entirely untrue.

Please check and fix your scripting, because it's broken.

                 Linus
