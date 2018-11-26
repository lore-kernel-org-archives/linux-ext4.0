Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41949 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeKZNrE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2018 08:47:04 -0500
Received: by mail-ed1-f66.google.com with SMTP id z28so14516326edi.8
        for <linux-ext4@vger.kernel.org>; Sun, 25 Nov 2018 18:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20181121024400.4346-1-devel@etsukata.com> <20181121045440.GM32577@ZenIV.linux.org.uk>
 <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com> <20181122070650.GN32577@ZenIV.linux.org.uk>
In-Reply-To: <20181122070650.GN32577@ZenIV.linux.org.uk>
From: Eiichi Tsukata <devel@etsukata.com>
Date: Mon, 26 Nov 2018 11:54:06 +0900
Message-ID: <CANhTXPSsh8mdedkm6wVAAQXk3wY7J2aSdgojZGxFR+ctArBsJw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2018=E5=B9=B411=E6=9C=8822=E6=97=A5(=E6=9C=A8) 16:06 Al Viro <viro@zeniv.li=
nux.org.uk>:
>
> Can you show me where does POSIX/SuS/whatever it's called these days prom=
ise
> that kind of atomicity?

No. I couldn't found it.
That's why I previously posted RFC Patch:
https://marc.info/?t=3D154237277900001&r=3D1&w=3D2
I wasn't sure this is a bug in the kernel or not.

> that kind of atomicity?  TBH, I would be very surprised if any Unix promi=
sed
> to have file size updated no more than once per write(2).  Any userland c=
ode
> that relies on such property is, as minimum, non-portable and I would arg=
ue
> that it is outright broken.

Thanks. Now It's clear. It is not a bug in the kernel, but in
userspace if `tail` assumes such
atomicity.

> Note, BTW, that your example depends upon rather non-obvious details of e=
cho
> implementation, starting with the bufferization logics used by particular
> shell.  And AFAICS ash(1) ends up with possibility of more than one write=
(2)

I've never imagined such a difference in echo implementation, thanks.
