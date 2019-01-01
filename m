Return-Path: <SRS0=/7aD=PJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46113 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfAAXlE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2019 18:41:04 -0500
Received: by mail-qt1-f195.google.com with SMTP id y20so32008949qtm.13
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2019 15:41:04 -0800 (PST)
MIME-Version: 1.0
References: <20181225053326.7012-1-tytso@mit.edu> <CANQeFDAL=Bx6dq69Rzmz_OWXkXMz=KzLvEkw4rQSSqMW9OHWMQ@mail.gmail.com>
 <20181226040713.GA4158@mit.edu>
In-Reply-To: <20181226040713.GA4158@mit.edu>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 1 Jan 2019 15:40:52 -0800
Message-ID: <CANQeFDBmnp=GJxzTw9ntPjK5rn2-MU8OTyzuVLCytnQTnj031A@mail.gmail.com>
Subject: Re: [PATCH] ext4: make sure enough credits are reserved for
 dioread_nolock writes
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 25, 2018 at 8:07 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Dec 25, 2018 at 04:10:25PM -0800, Liu Bo wrote:
> >
> > I had a patch[1] to address the problem but with adding reservation
> > only when we need to (in ext4_ext_try_to_merge_up).
>
> Sorry, I had forgotten that you had that patch pending.  I believe
> that merging up isn't the only case we need to worry about, though.
> For example, if we write into the middle of a larger unwritten region,
> we might havec to change a single region into three regions, which
> might require a node split --- and in that case, it's not optional, as
> would be in the try_to_merge_up situation.  If we don't have enough
> credits to do a node split our only choices would be mark the file
> system as corrupted, or to fail the write with ENOSPC (which would be
> very confusing to the user/application).
>

I see it now, thanks for the explanation.

thanks,
liubo

> Cheers,
>
>                                         - Ted
