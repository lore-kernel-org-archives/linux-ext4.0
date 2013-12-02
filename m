From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable punch hole for bigalloc
Date: Mon, 2 Dec 2013 10:01:19 -0500
Message-ID: <20131202150119.GE25294@thunk.org>
References: <1385820218-4673-1-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1312021225080.3930@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35640 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3LBPBZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 10:01:25 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1312021225080.3930@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 12:29:32PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> I actually send out this patch as a part of the series which
> implemented it and it even got review for Jan Kara
>=20
> http://www.spinics.net/lists/linux-ext4/msg37914.html
>=20
> however Ted noticed that xfstest shared/298 failed, but that was not
> due to bug in the code,but rather the problem with the test itself,
> see:
>=20
> https://lkml.org/lkml/2013/6/18/329
>=20
> So I am not sure why it was not merged a long time ago. Ted probably
> just overlooked my response.

Sorry, I did see your response, but I then forgot to get your original
patch.  Thanks, applied.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
