From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Tue, 10 Jul 2007 00:12:18 +0200
Message-ID: <20070709221218.GB18501@lazybastard.org>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru> <20070709083431.GA14761@lazybastard.org> <20070709180148.GA5747@martell.zuzino.mipt.ru> <20070709200003.GA18501@lazybastard.org> <1184018540.6820.5.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:38426 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXGIWPv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 18:15:51 -0400
Content-Disposition: inline
In-Reply-To: <1184018540.6820.5.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 July 2007 17:02:20 -0500, Dave Kleikamp wrote:
>=20
> It's not a direct call to a static function.  It is called as a
> super_ops method.  I don't think the overhead is very significant, bu=
t
> it doesn't look like it could do any harm.

Ah, I missed that fact.  Yep, looks fine to me.

J=C3=B6rn

--=20
Joern's library part 7:
http://www.usenix.org/publications/library/proceedings/neworl/full_pape=
rs/mckusick.a
