Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43662 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbfAPGWm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2019 01:22:42 -0500
MIME-Version: 1.0
References: <20190102174736.GB29127@quack2.suse.cz> <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz> <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
In-Reply-To: <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 Jan 2019 08:22:29 +0200
Message-ID: <CAOQ4uxgcXUh=zj4J_=Hk4+7qXuSS5bq3picj+8ofyTCa0DnsbA@mail.gmail.com>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2019 at 4:56 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jan 15, 2019 at 9:24 PM Jan Kara <jack@suse.cz> wrote:
> >
> > What has happened to this pull request? It may be too late for this to be
> > merged now but I'd like to understand why it was not merged or rejected...
>
> Sorry, initially I left if for later consideration after rc1, and then
> I just forgot about it.
>
> I didn't see much point to the cleanup when it actually adds lots of
> lines and no actual advantage. The whole dentry type translation
> really is fs-specific and it might just happen to be shared. But why
> share it if it only adds complexity and unnecessary abstraction?
>

Linus,

I guess some of the reasoning got lost from the original patch series
to the pull request.

The pull request fails to mention this is an ext2 (very very old) bug fix.

Jan has agreed to carry these 2 patches first to ease to herding all
other filesystem patches in the series:
https://marc.info/?l=linux-fsdevel&m=154060161813861&w=2
https://marc.info/?l=linux-fsdevel&m=154289087825040&w=2

The overall cleanup reduces ~100LOC and was acked by many filesystem
maintainers as a welcome improvement (not as added complexity)
Instead of fixing a potential out-of-bounds access bug that was copy&pasted
from ext2 to many other filesystems, the approach taken was to create a single
correct implementation and use it in all those filesystems.

It is true, that this is filesystem specific code and new filesystem on-disk
formats is not bound to use the same values. But the on-disk values used
for all those filesystems formats are not going to change for eternity, so there
is no meat on the fs-specific argument. The conversion is common de-facto
forever for code that wants to read inodes from existing drives.

If you pull these 2 patches now, other patches could be applied by
fs maintainers for next cycle.

Thanks,
Amir.
