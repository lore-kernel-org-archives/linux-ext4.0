From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Sat, 17 Apr 2010 15:45:47 -0500
Message-ID: <4BCA1DFB.5030501@redhat.com>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andre Noll <maan@systemlinux.org>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0DQUqW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Apr 2010 16:46:22 -0400
In-Reply-To: <201004171855.36874.bernd.schubert@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bernd Schubert wrote:
=2E..

> Altogether filesystem unrelated. The filesystem just might be the rea=
son for a=20
> synchronize-cache, e.g. barriers, etc.

Interesting that it only happens at enospc time though - the fs would
be sending barriers in general usage.

Although, as ext4 fills, it does do more syncing/flushing to try to
eke out that last bit of space.... hmm....

Andre, just for fun, you might try mounting -o nodelalloc, fill it agai=
n,
and see if you see the same behavior.

If not, you might do it again w/ defaults, and capture blktrace data, w=
hich
I think will trace barrier requests as well.

(or, maybe also try testing with -o nobarrier)

I still don't think it's likely a filesystem problem but maybe you can
pinpoint the fs behavior that triggers it.

-Eric
=20
> Greetings from T=FCbingen,
> Bernd=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
