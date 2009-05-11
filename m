From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 12:06:24 +0200
Message-ID: <20090511100624.GB6585@logfs.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:33598 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbZEKKGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 06:06:43 -0400
Content-Disposition: inline
In-Reply-To: <20090511083754.GA29082@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 May 2009 04:37:54 -0400, Theodore Tso wrote:
>=20
> Well, no one has actually implemented the low-level TRIM support yet;

Iirc dwmw2 did so for some of the FTL drivers.  More a curiosity than a
useful device, though.

> Well, no, Matthew's changes didn't do any of that, I suspect because
> most SSD's, including X25-M, are expected to have a granularity size
> of 1 block.  It's the crazy people in the SCSI standards world who've
> been pushing for granlarity sizes in the 1-4 megabyte range; as I
> understand things, the granularity issue was not going to be a proble=
m
> for the ATA TRIM command.

I am not sure about this part.  So far Intel has been the only party to
release any information about their dark-grey box.  All other boxes are
still solid black.  And until I'm told otherwise I'd consider them to b=
e
stupid devices that use erase block size as trim granularity.

Given the total lack of information, your guess is as good as mine,
though.

> As far as thinking that the proposal is ludicrous --- what precisely
> did you find ludicrous about it?

Mainly the idea that discard requests should act as barriers and instea=
d
of fixing that, you propose a lot of complexity to work around it.

> The only problem with SSD's is the people who designed the ATA TRIM
> command requires us to completely drian the I/O queue before issuing
> it.  Because of this incompetence, we need to be a bit more careful
> about how we issue them.

And this bit that I wasn't aware of.  Such a requirement in the standar=
d
is a trainwreck indeed.

J=C3=B6rn

--=20
Victory in war is not repetitious.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
