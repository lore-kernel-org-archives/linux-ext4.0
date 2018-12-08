Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37471 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeLHV7L (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 16:59:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id e5-v6so6469851lja.4
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 13:59:10 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id c203sm1287720lfe.95.2018.12.08.13.59.07
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Dec 2018 13:59:08 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id u6-v6so6470439ljd.1
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 13:59:07 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
In-Reply-To: <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 8 Dec 2018 13:58:51 -0800
Message-ID: <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 8, 2018 at 1:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes, allowing concurrent use then generates whole new "interesting"
> questions, like "what happens if a case _sensitive_ user creates two
> files with names that are identical to a in-sensitive user", but they
> aren't necessarily any worse than the issues you face *not* allowing
> that.

I'm hoping you are at least doing it per-directory. That makes at
least the "oh, the whole filesystem needs to do this wrong" issue a
bit less bad.

Just looking at the shortlog you posted, my guess is that the ext4
patches didn't even get *that* right, though. That shortlog "encoding
information in superblock" implies this is the same kind of just
horribly bad mess that we've seen before.

I really despise every single case-sensitive filesystem I have ever
seen, exactly because nobody apparently spends even a minimal amount
of effort on getting any of the basics remotely right. Every single
case I've seen has been a huge nasty hack, with seriously bad
system-wide consequences.

                  Linus
