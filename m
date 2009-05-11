From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 14:43:25 +0200
Message-ID: <20090511124325.GC6585@logfs.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:49573 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZEKMnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 08:43:49 -0400
Content-Disposition: inline
In-Reply-To: <20090511112729.GD29082@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 May 2009 07:27:29 -0400, Theodore Tso wrote:
>=20
> I can't fix hardware braindamage.  Given that the standard
> specifications is terminally broken, (and we can't really fix it
> without getting the drive manufacturers to rip out and replace NCQ
> with something sane --- good luck with that) the complexity is pretty
> much unaviodable.  Still think my proposal is ludicrous?

Given the hardware braindamage it is relatively sane.  As always, it
would be much better to fix the problem and not add workarounds, but we
seem to lack the gods favor this time around.

Can't anyone explain to the SATA folks that a discard is much closer to
a write than to a secure erase or some other rare and slow command?

J=C3=B6rn

--=20
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
