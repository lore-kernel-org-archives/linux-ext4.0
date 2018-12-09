Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39702 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeLIUxd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2018 15:53:33 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org, sfrench@samba.org
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
References: <20181206230903.30011-1-krisman@collabora.com>
        <20181208194128.GE20708@thunk.org>
        <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
        <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
        <20181209050326.GA28659@mit.edu>
        <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
Date: Sun, 09 Dec 2018 15:53:28 -0500
In-Reply-To: <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 9 Dec 2018 09:41:13 -0800")
Message-ID: <871s6qo20n.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Dec 8, 2018 at 9:03 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:

> Either you have a horrible fundamental design mistake that has
> different per-filesystem locales, or you don't.
>
> If you don't, you shouldn't be touching any of the nls code.
>
> Whatever unicode tables you use for case folding shouldn't be in the nls code.

Hi Linus,

As Ted mentioned the SMB case, in my understanding, we might have more
users for in-kernel ut8 normalization/casefold comparison functions than
just ext4 in the future.  Steve French (in cc.), for instance, mentioned
his interest in using this higher level NLS API when I first submitted
these patches.

My first RFC actually included this code as a separated module inside
lib/ instead of touching NLS, but I found myself rewriting much of the
same APIs that already existed in NLS.  That is why I merged my work
with that subsystem.  I am open to rethinking it, if there is a better
alternative.

Thanks,

-- 
Gabriel Krisman Bertazi
