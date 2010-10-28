From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for 2.6.37)
Date: Thu, 28 Oct 2010 08:12:50 -0400
Message-ID: <698D7018-682F-4D8A-A3A6-079514669D9F@mit.edu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:42493 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177Ab0J1MM5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 08:12:57 -0400
In-Reply-To: <20101028075631.GA7690@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 28, 2010, at 3:56 AM, Ingo Molnar wrote:

>=20
> hi Ted,
>=20
>> Theodore Ts'o (18):
>>      ext4: rename {exit,init}_ext4_*() to ext4_{exit,init}_*()
>=20
> Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: re=
name=20
> {exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config=
 with=20
> CONFIG_EXT4_FS_XATTR disabled:
>=20
>  fs/ext4/super.c:4776: error: implicit declaration of function =91ext=
4_init_xattr=92
>=20
> Commit 5dabfc7 renamed init_ext4_xattr to ext4_init_xattr but forgot =
to update the=20
> definition in fs/ext4/xattr.h. The patch below fixes it.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks for catching this, my bad.

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
