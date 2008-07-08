From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 09:10:27 +1000
Message-ID: <20080708231026.GP11558@disturbed>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:53291 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYGHXKc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 19:10:32 -0400
Content-Disposition: inline
In-Reply-To: <20080707110730.GG5643@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > I still disagree with this whole patch.  There is not reason to let
> > the freeze request timeout - an auto-unfreezing will only confuse t=
he
> > hell out of the caller.  The only reason where the current XFS free=
ze
> > call can hang and this would be theoretically useful is when the
>=20
> What happens when someone dirties so much data that vm swaps out
> whatever process that frozen the filesystem?

a) you can't dirty a frozen filesystem - by definition a frozen
   filesystem is a *clean filesystem* and *cannot be dirtied*.
b) Swap doesn't write through the filesystem
c) you can still read from a frozen filesystem to page your
   executable=D1=95 in.
d) if dirtying another unfrozen filesystem swaps out your
   application so it can't run, then there's a major VM bug.
   Regardless, until the app completes it is relying on the
   filesystem being frozen, so it better remain frozen....

> I though that was why the timeout was there...

Not that I know of.=20

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
