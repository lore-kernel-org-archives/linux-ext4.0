Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40381 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbfAORg0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2019 12:36:26 -0500
Received: by mail-lf1-f65.google.com with SMTP id v5so2677595lfe.7
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 09:36:25 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id e14-v6sm654975ljb.31.2019.01.15.09.36.22
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 09:36:23 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id a16so2697634lfg.3
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 09:36:22 -0800 (PST)
MIME-Version: 1.0
References: <20190102174736.GB29127@quack2.suse.cz> <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz>
In-Reply-To: <20190115092414.GA4138@quack2.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2019 05:36:06 +1200
Message-ID: <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2019 at 9:24 PM Jan Kara <jack@suse.cz> wrote:
>
> What has happened to this pull request? It may be too late for this to be
> merged now but I'd like to understand why it was not merged or rejected...

Sorry, initially I left if for later consideration after rc1, and then
I just forgot about it.

I didn't see much point to the cleanup when it actually adds lots of
lines and no actual advantage. The whole dentry type translation
really is fs-specific and it might just happen to be shared. But why
share it if it only adds complexity and unnecessary abstraction?

               Linus
