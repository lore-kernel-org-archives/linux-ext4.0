Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35696 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbeLJTfi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 14:35:38 -0500
Received: by mail-lf1-f65.google.com with SMTP id e26so8913897lfc.2
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2018 11:35:36 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id e5-v6sm2273318ljj.91.2018.12.10.11.35.33
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 11:35:34 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id c19-v6so10752941lja.5
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2018 11:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <20181209050326.GA28659@mit.edu> <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
 <20181209201043.GA1840@mit.edu> <CAHk-=wh9CXVF6VZ8ZN5aRoRZyPb5ZME3LqNspPNd3LwQFHJT0Q@mail.gmail.com>
 <20181210000822.GD1840@mit.edu>
In-Reply-To: <20181210000822.GD1840@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Dec 2018 11:35:17 -0800
Message-ID: <CAHk-=wiFtZL5rK3T-HQPm0oG4vekDJEKS47P8BbzHSXt_6SHuA@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 9, 2018 at 4:08 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> So things are much better in recent years.  In the past it was kind of
> a disaster, but the world is converging enough that the latest
> versions of Mac OS'x APFS and Windows NTFS behave pretty much the same
> way.  They are both case-insensitive, case-preserving and
> normalization-preserving, normalization-insensitive with respect to
> filenames.

Oh, so APFS at least fixed *that* horrific problem with their
filesystem. Oh how I despised the exposure of NFD (which should at
most be used as an internal representation, not externally visible).
Turning basic letters (coming from Finland, =C3=A5=C3=A4=C3=B6) into charac=
ter
combinations was an absolute abomination.

> In the bad old-days, MacOS X's HFS+ was not normalization-preserving.

Oh, I'm very aware.

It's not even that it wasn't normalization-preserving, it picked the
*wrong* normalization to use.

> Now, both file systems basically say, "we don't care whether you pass
> in U+212B or U+0041,U+030A; on the screen it looks identical, =C3=85, so =
we
> will treat it as the same filename; but readdir(2) will return what
> you gave us."

Actually, the "on the screen it will look identical" is a horribly
incorrect thing to do too.

There are lots of things that look identical on the screen without
being at all the same thing. Sometimes it depends on font, sometimes
it's just how it is. A nonbreaking space is *not* the same as a
regular space, even if they may look identical on the screen.

I suspect (and sincerely _hope_) neither filesystem actually does
anything as stuipid as taking "glyph equivalence" into account.

I'm hoping it's just "convert to NFx, then lower-case, then compare
for equality". Where the 'x' doesn't much matter as long as it is
never _exposed_ in any way outside of the comparison (ie NFD is a fine
and probably simpler model for the lower-casing, the HFS+ mistake was
to then expose the corrupted form of the filename).

> It's been a *long* time since Unicode has changed case folding rules
> for pre-existing characters.  The tables have only changed with
> respect to the new character sets have been added.

But new characters _have_ been added, and some of them do have
lower-case form, so the folding tables have changed.

Happily, maybe that is over. As long as the Unicode people continue to
mainly play with their Emoji list, I guess we can consider it done.

> So how about this?  We'll put the unicode handling functions in a new
> directory, fs/unicode, just to make it really clear that this will now
> be changing any of the legacy fs/nls functions which other file
> systems will use.  By putting it in a separate directory, it will be
> easier for other file systems to use it, whether it's for better Samba
> or NFSv4 support.

Ok, that sounds fine.

Some of the unicode translation functions from the NLS code could well
move into that, and NLS itself could be relegated to the sad
historical thing.

And please try to make the *interfaces* sane.

For example, the interface for "let's compare with folded case" should
*not* be about "convert to NFDK and lower case into a temp buffer,
then compare the results".

You can do a lot of "let's handle the simple cases" faster even if the
"oh, I hit a complex character" case might then become one of those
"convert to a temp buffer" cases.

And it shouldn't be about C strings, since we very much have cases
where it's not a C string but a {ptr,len} tuple. Maybe even use the
"struct qstr", which is a not-horrible way to pass those around.

Even if you have a C string, you can always just do

        struct qstr str =3D QSTR_INIT(name, strlen(name));

and then pass that qstr pointer around.

Finally, don't do the NLS thing with "descriptors". that you register
and look up. The indirection kills you. Particularly the crazy "one
character at a time" model.

Just let people explicitly say "utf8_icasecmp(qstr, qstr)" or
something like that.  With the interface at least allowing for the
common simple cases (ie everything is in the ASCII subset) to be
handled basically as a specialized thing.

                    Linus
