From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] e2p: fix getflags for link file
Date: Wed, 6 Dec 2017 08:41:19 +0800
Message-ID: <CAP9B-Q=ady2ni+YRaQwFQuWtmJBmN0FKj7wSpv0-5vzTZEthkw@mail.gmail.com>
References: <1512395795-10022-1-git-send-email-wshilong1991@gmail.com> <20171205161010.2q2owkepbk6zg2hp@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:38640 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753125AbdLFAlV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Dec 2017 19:41:21 -0500
Received: by mail-lf0-f66.google.com with SMTP id e137so2372588lfg.5
        for <linux-ext4@vger.kernel.org>; Tue, 05 Dec 2017 16:41:21 -0800 (PST)
In-Reply-To: <20171205161010.2q2owkepbk6zg2hp@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 6, 2017 at 12:10 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Dec 04, 2017 at 10:56:35PM +0900, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> >
> > Steps to reproduce:
> >
> > $ touch a
> > $ lsattr -dp a
> >  2000 ----------------P a
> > $ ln -s a b
> > $ lsattr -dp b
> > lsattr: Operation not supported While reading flags on b
> >
> > Link files should be supported, fix it.
> >
> > Signed-off-by: Wang Shilong <wshilong@ddn.com>
>
> You can't actually set or get the extended attributes for a symlink;
> the *kernel* doesn't support what you seem to be hoping to achieve.
> This patch result in fgetflags() following the symlink and opening
> whatever file it points at.

Yup, you are right.

But this is one of our customers feedback, this is not good that
lsattr/chattr did not support symlink, we might need make it
clear, for example, we support symlink, but it always follow
original files, that is even better than output errors.

In this way, we need fix chattr too.

What do you think?


Thanks,
Shilong


>
>                                                 - Ted
