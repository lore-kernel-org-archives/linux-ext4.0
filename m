Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40652 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeKVPBx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 10:01:53 -0500
Received: by mail-ed1-f65.google.com with SMTP id d3so6586228edx.7
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 20:24:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/3] Fix panic with journal superblock flags printing.
From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
In-Reply-To: <20181121235432.GE10588@thunk.org>
Date: Thu, 22 Nov 2018 07:24:17 +0300
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC847396-EE31-4F96-B8A9-3457FD1AC9F5@gmail.com>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-3-alexey.lyashkov@gmail.com>
 <20181121235432.GE10588@thunk.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1024 is jbd superblock size, and this constant widely used over =
e2fsprogs code.
from this particular case it=E2=80=99s clear bug as jsb_buffer defined =
as.
>>
        char                    jsb_buffer[1024];
>>


> 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3., =D0=B2 2:54, Theodore Y. =
Ts'o <tytso@mit.edu> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> The summary really isn't right; "panic" is something that kernels do,
> not userspace programs.
>=20
>> -	if (dump_super) {
>> +	if (dump_all || dump_super) {
>> 		e2p_list_journal_super(out_file, jsb_buffer,
>> -				       current_fs->blocksize, 0);
>> +				       1024, 0);
>=20
> This makes no sense to me.  Why is hard-coding the expected blocksize
> to be 1024 a good thing to do here?
>=20
> 					- Ted
