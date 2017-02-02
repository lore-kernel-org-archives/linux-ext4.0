From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] mke2fs: enable large directroy support
Date: Thu, 2 Feb 2017 10:11:28 -0700
Message-ID: <74D6C84E-BC8B-4060-9345-3DC8DAEB9EED@dilger.ca>
References: <CAO3qy=F_CxQQ0bUtOm5CZbE0QQ78vyviMStOgg8nryUZZymung@mail.gmail.com> <20170125203121.s2o4cskgmruvjnrt@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36758 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdBBRLb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Feb 2017 12:11:31 -0500
Received: by mail-it0-f65.google.com with SMTP id f200so6478193itf.3
        for <linux-ext4@vger.kernel.org>; Thu, 02 Feb 2017 09:11:30 -0800 (PST)
In-Reply-To: <20170125203121.s2o4cskgmruvjnrt@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have kernel-side patches for this feature. Artem, could you push a versio=
n of the ext4 patches for the latest kernel to the list?

Cheers, Andreas

> On Jan 25, 2017, at 13:31, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
>> On Tue, Jan 24, 2017 at 07:34:13PM +0300, Artem Blagodarenko wrote:
>> The INCOMPAT_LARGEDIR feature allows larger directories to
>> be created, both with directory sizes over 2GB and and a
>> maximum htree depth of 3 instead of the current limit of 2.
>> These features are needed in order to exceed the currently
>> limit of approximately 10M entries in a single directory.
>>=20
>> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
>> added.
>>=20
>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> Where are the kernel-side changes for this feature?
>=20
> And could you *please* use git send-email's --chain-reply-to option,
> or set the sendemail.chainReplyTo in your git config.  (Or if you're
> not using git send-email, send the e-mail using that format).
>=20
> It makes it much easier to figure out which patch goes with which
> other patch in a patch series, especially when you start sending
> revised versions of the patches.
>=20
>                    - Ted
>=20
