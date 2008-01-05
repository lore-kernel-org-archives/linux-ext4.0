From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Sat, 05 Jan 2008 07:47:36 +0300
Message-ID: <477F0BE8.60307@gmail.com>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Richard Knutsson <ricknu-0@student.ltu.se>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:49040 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYAEEtF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 23:49:05 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3739679fga.17
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2008 20:49:04 -0800 (PST)
In-Reply-To: <20080105041228.GP3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Jan 04, 2008  14:41 +0100, Richard Knutsson wrote:
>>>  @@ -54,6 +54,6 @@ int __ext4_journal_dirty_metadata(const char *wh=
ere,
>>>  {
>>>  	int err =3D jbd2_journal_dirty_metadata(handle, bh);
>>>  	if (err)
>>> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
>>> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>>>  	return err;
>>>  }
>> What about changing the __FUNCTION__ to __func__, while you are at i=
t?
>=20
> What's wrong with __FUNCTION__?  I thought that was ANSI C?

No, it was not. The ANSI C 1990 Standard defines the following so-calle=
d
"predefined macros": __LINE__, __FILE__, __DATE__, __TIME__, and __STDC=
__.
The ISO/IEC 9899 Standard commonly referred to as the C99, defines a fe=
w
additional predefined macros, as well as an additional predefined
identifier __func__. For more information please refer to the ISO/IEC 9=
899
document itself, which is freely available for download at the time of
me writing this.

Although seemingly "natural", the __FUNCTION__ macro has never been par=
t
of the C Standard.

Dmitri

>=20
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
