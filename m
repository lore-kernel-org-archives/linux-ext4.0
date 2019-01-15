Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731121AbfAOSB6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2019 13:01:58 -0500
Date: Tue, 15 Jan 2019 10:01:56 -0800
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
Message-ID: <20190115180156.GB6310@bombadil.infradead.org>
References: <20190102174736.GB29127@quack2.suse.cz>
 <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz>
 <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2019 at 05:36:06AM +1200, Linus Torvalds wrote:
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

The ext2/ext4 patches don't show much improvement.  The other patches show
more:

 fs/nilfs2/dir.c                    | 52 ++++++++++--------------------
 include/uapi/linux/nilfs2_ondisk.h |  1 +
 2 files changed, 18 insertions(+), 35 deletions(-)

(for example).

UFS ends up benefiting the most.  You can see the whole diffstat here:

https://lore.kernel.org/lkml/20181023201952.GA15676@pathfinder/

We'd see a lot more improvement in line count if Philip weren't quite
so paranoid about checking FOOFS_FT_* == FT_* at build time; eg for btrfs:

https://lore.kernel.org/lkml/20181023211728.GA16584@pathfinder/
