Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40905 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeLIRle (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2018 12:41:34 -0500
Received: by mail-lf1-f68.google.com with SMTP id v5so6342490lfe.7
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 09:41:33 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id a127sm1694369lfe.73.2018.12.09.09.41.30
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 09:41:31 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id t9-v6so7570142ljh.6
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 09:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com> <20181209050326.GA28659@mit.edu>
In-Reply-To: <20181209050326.GA28659@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Dec 2018 09:41:13 -0800
Message-ID: <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 8, 2018 at 9:03 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Whether or not case-folding is being done is per-directory (it's a
> flag on the directory set by chattr) .  What encoding is supported
> (and we only will support two, ASCII and UTF-8) is per-file system.  I
> personally believe it's insane to try to encode a large number of
> encodings, like big5, or iso-8859-1, etc. on a per-directory basis.
> Either don't do encodings at all, or use utf-8.  Period.  I believe
> you made a similar request for git metadata, no?   :-)

Absolutely.

But if you only support ascii or utf-8, then why are you messing with
the nls part? That makes no sense.

You can't have it both ways.

Either you have a horrible fundamental design mistake that has
different per-filesystem locales, or you don't.

If you don't, you shouldn't be touching any of the nls code.

Whatever unicode tables you use for case folding shouldn't be in the nls code.

                 Linus
