Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35761 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeLIVFs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2018 16:05:48 -0500
Received: by mail-lj1-f196.google.com with SMTP id x85-v6so7827720ljb.2
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 13:05:46 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id u15-v6sm1952376lja.63.2018.12.09.13.05.44
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 13:05:44 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id s5-v6so7772599ljd.12
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 13:05:44 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <20181209050326.GA28659@mit.edu> <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
 <871s6qo20n.fsf@collabora.com>
In-Reply-To: <871s6qo20n.fsf@collabora.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Dec 2018 13:05:27 -0800
Message-ID: <CAHk-=whtEo0MdPiWX3+=UPZa3FMVF-q0=0K8=VrTdQ6jMux8wA@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: krisman@collabora.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org, sfrench@samba.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 9, 2018 at 12:53 PM Gabriel Krisman Bertazi
<krisman@collabora.com> wrote:
>
> As Ted mentioned the SMB case, in my understanding, we might have more
> users for in-kernel ut8 normalization/casefold comparison functions than
> just ext4 in the future.

Crossed emails.

See my note about how there really is not a single case-folding
library. It's simply not physically possible, because there are so
many different ideas about what case-folding actually means.

That's still true even if "everything is utf-8", sadly.

So how do you handle locale issues and things like "we have ten
different tables for utf-8 comparisons, and that's _ignoring_ the
issue of whether we combine or decompose characters"?

And there's no way you can use the existing nls interfaces for
upper/lower case, for example, since they are all limited to 256-byte
tables and direct accesses to said tables, afaik.

And if that is where the extensions were, and that is why you changed
other filesystems, this all matters.

My *guess* is that what you really want is not really about unicode at
all, but specifically about just the NTFS rules. Which, yes, might
find generic sharing interest between cifs/ext4/etc, but my gut feel
is that they'd be specifically about some NTFS interoperability
library.

Because even then I think you might have issues like "NTFS-5.1" vs
"NTFS-4.0" etc.

Maybe you don't care, and you're picking just *one* version. And I
haven't seen the code.

Basically, I would not be surprised if the sanest model is simply to
make a "ntfs" library. Because I'm really fairly sure that OS X rules
are very different indeed, even if it too is "unicode".

                 Linus
