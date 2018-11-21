Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:37879 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbeKVDPm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 22:15:42 -0500
Received: by mail-io1-f65.google.com with SMTP id a3so4523222ioc.4
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 08:40:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] Ext4: fix slow writeback under dioread_nolock and
 nodelalloc
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
In-Reply-To: <20181121000718.GC6401@thunk.org>
Date: Wed, 21 Nov 2018 19:40:23 +0300
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F65698E8-8FFD-4C79-98EF-9971FE5719EB@gmail.com>
References: <1542694270-47732-1-git-send-email-bo.liu@linux.alibaba.com>
 <20181121000718.GC6401@thunk.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore,

> On 21 Nov 2018, at 03:07, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> *) Drop support for nodelalloc, and make delayed allocation the
>   default.  (This requires dropping data=3Djournal mode, since
>   data=3Djournal mode does not co-exist with delalloc.)
>=20
> The last was assuming that there really wasn't good use cases where
> people would really want to use nodelalloc, aside from ext3
> bug-for-bug compatibility, and hopefully since most people are using
> ext4 these days, it becomes easier to make the case tha we don't need
> to support ext3's unusual performance attributes.

Currently Lustre FS uses =E2=80=9Cnodelalloc=E2=80=9D option at least =
because of this two reasons:

- OSD (layer that interact with EXT4 (LDISKFS backend) expect =
synchronous behaviour.

- delalloc optimise block allocation the way useless for Lustre FS, =
because data is striped across of OSTs.=20
Lustre FS has its own optimisations. Its behaviour similar with =
data=3Djournal journaling mode. =E2=80=9CJournal=E2=80=9D is stored on =
clients and OST recovery is like journal replay.

Best regards,
Artem Blagodarenko.=
