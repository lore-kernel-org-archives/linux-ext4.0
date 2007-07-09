From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Mon, 9 Jul 2007 22:00:03 +0200
Message-ID: <20070709200003.GA18501@lazybastard.org>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru> <20070709083431.GA14761@lazybastard.org> <20070709180148.GA5747@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, akpm@osdl.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:59264 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXGIUDa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 16:03:30 -0400
Content-Disposition: inline
In-Reply-To: <20070709180148.GA5747@martell.zuzino.mipt.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 July 2007 22:01:48 +0400, Alexey Dobriyan wrote:
>=20
> Yes. Note that ext2_clear_inode() is referenced from ext2_sops, so ev=
en
> empty, it leaves traces in resulting kernel.

Is that your opinion or have you actually measured a difference?
I strongly suspect that compilers are smart enough to optimize away a
call to an empty static function.

J=C3=B6rn

--=20
=46ancy algorithms are slow when n is small, and n is usually small.
=46ancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
