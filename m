From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Thu, 19 Jul 2007 17:31:41 -0700
Message-ID: <20070719173141.51217ba8.akpm@linux-foundation.org>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru>
	<20070709083431.GA14761@lazybastard.org>
	<20070709180148.GA5747@martell.zuzino.mipt.ru>
	<20070709200003.GA18501@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758423AbXGTAcW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 20:32:22 -0400
In-Reply-To: <20070709200003.GA18501@lazybastard.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 Jul 2007 22:00:03 +0200
J=F6rn Engel <joern@logfs.org> wrote:

> On Mon, 9 July 2007 22:01:48 +0400, Alexey Dobriyan wrote:
> >=20
> > Yes. Note that ext2_clear_inode() is referenced from ext2_sops, so =
even
> > empty, it leaves traces in resulting kernel.
>=20
> Is that your opinion or have you actually measured a difference?
> I strongly suspect that compilers are smart enough to optimize away a
> call to an empty static function.
>=20

It saves a big 16 bytes of text here.
