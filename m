Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35280 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeLIUy6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2018 15:54:58 -0500
Received: by mail-lj1-f195.google.com with SMTP id x85-v6so7815354ljb.2
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 12:54:57 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id e13-v6sm1775075ljk.53.2018.12.09.12.54.54
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 12:54:55 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id 83-v6so7789815ljf.10
        for <linux-ext4@vger.kernel.org>; Sun, 09 Dec 2018 12:54:54 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <20181209050326.GA28659@mit.edu> <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
 <20181209201043.GA1840@mit.edu>
In-Reply-To: <20181209201043.GA1840@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Dec 2018 12:54:38 -0800
Message-ID: <CAHk-=wh9CXVF6VZ8ZN5aRoRZyPb5ZME3LqNspPNd3LwQFHJT0Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 9, 2018 at 12:10 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Gabriel added the Unicode tables for case folding to the fs/nls
> directory.  If you'd prefer that we put them somewhere else, we
> can; do you have a preference?

I have a really hard time judging, since I haven't seen the code, just
a random diffstat and shortlog.

First off, there is no such thing as "one" unicode table for case
folding. There are lots and lots of tables, and I'm not clear what
table it is all about.

For example, both OS X and Windows do some form of case folding on
unicode. They don't do the *same* folding, though.

There are also various locale variations to case folding. This is
where I thought your nls choice came from, but then you tried to imply
that there are no locale issues and that directories can just have a
single flag to enable/disable the folding.

In some locales, "SS" and "=C3=9F" (perhaps "SZ" too) will compare the same
in case-insensitivity. Crazy in general, and afaik modern unicode even
has a real upper-case "=C3=9F" so it's arguably legacy, but...

And that's all entirely independent of the issues with all the
combining characters, modifier letters, white-space, overlong utf8
questions, etc etc.

It's also easy to generate overlong utf-8 that decodes to '/', for
example. Some broken systems might consider that identical to a real
'/' and it matters for path lookup.

So what's the actual code? What rules did you happen to pick? Did you
take the windows rules as-is (I _think_ they may be documented) since
the primary target apparently is just samba performance?

And even if the answer is "we follow NTFS rules", which *version* of
NTFS folding rules are you using if you're trying to speed up samba,
for example? Because afaik they have changed over time.

Is the *only* target samba? You are never interested for local loads
like "oh, people want to run Wine and might need it" or the
application testing parts?

All of these matter.

For example, if it's some "ext4 special case just for samba", then
perhaps the logical place to put all this is just in fs/ext4/ and not
bother anybody else about it.

But if it might be useful as some generic "NTFS hashing" library, then
make it that.

                   Linus
