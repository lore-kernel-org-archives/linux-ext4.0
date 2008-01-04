From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 04 Jan 2008 14:47:24 +0100
Message-ID: <8763y9em8j.fsf@barad-dur.regala.cx>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx>
	<477E379F.4000103@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:51011
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYADN5H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 08:57:07 -0500
In-Reply-To: <477E379F.4000103@student.ltu.se> (Richard Knutsson's message of "Fri\, 04 Jan 2008 14\:41\:51 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vous m'avez dit r=E9cemment :

[snip]

> Hi Mathieu
>
> What about changing the __FUNCTION__ to __func__, while you are at it=
?

well, won't do any harm, even though other compilers than GCC are not
officialy supported :)

thanks a lot
And I think I will revamp, including fixes into fs/ext2

--=20
Mathieu
