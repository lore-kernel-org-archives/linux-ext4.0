Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34718 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436645AbeKVX1E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 18:27:04 -0500
MIME-Version: 1.0
References: <20181121190653.GA7710@pathfinder> <20181122114023.GE9840@quack2.suse.cz>
In-Reply-To: <20181122114023.GE9840@quack2.suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Nov 2018 14:47:39 +0200
Message-ID: <CAOQ4uxiOOJuFDO7x=sY9Cy3wGr8xo6AGKY4Hep10jwvOVkqd_A@mail.gmail.com>
Subject: Re: [RFC][PATCH v4 04/09] ext2: use common file type conversion
To: Jan Kara <jack@suse.cz>
Cc: Phillip Potter <phil@philpotter.co.uk>, Jan Kara <jack@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 22, 2018 at 1:40 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 21-11-18 19:06:53, Phillip Potter wrote:
> > Deduplicate the ext2 file type conversion implementation - file systems
> > that use the same file types as defined by POSIX do not need to define
> > their own versions and can use the common helper functions decared in
> > fs_types.h and implemented in fs_types.c
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
>
> Looks good. You can add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>

Jan,

As you know, Al probably has bigger fish to fry at the moment.
Will you take this patch along with patch #1 through your tree?
Other fs maintainers could apply patches on next cycle (or coordinate
they pull request with you).

If you would agree to that, I suggest to copy the following section
from the cover letter into the ext2 patch:

The current implementation has a lurking out-of-bounds access
bug to the ext2_type_by_mode array.
The array is defined with size S_IFMT >> S_SHIFT, so 15.
This means that it is possible with a malformed inode to
get an index of 15, as the array is always accessed with:
ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];

Thanks,
Amir.
