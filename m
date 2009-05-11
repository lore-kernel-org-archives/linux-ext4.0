From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 07:27:29 -0400
Message-ID: <20090511112729.GD29082@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58972 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZEKL1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 07:27:42 -0400
Content-Disposition: inline
In-Reply-To: <20090511100624.GB6585@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 12:06:24PM +0200, J=F6rn Engel wrote:
> I am not sure about this part.  So far Intel has been the only party =
to
> release any information about their dark-grey box.  All other boxes a=
re
> still solid black.  And until I'm told otherwise I'd consider them to=
 be
> stupid devices that use erase block size as trim granularity.

I believe the ATA TRIM draft standards specs don't have the 1-4
megabyte; that craziness is only coming from the SCSI world.  So we do
have more information than what Intel has released; also, note that
OCZ is the first vendor who has shipped publically available SSD
firmware with Trim support.  Supposely Intel is going to try to get me
their trim-enabled firmware under NDA, but that hasn't happened yet.

> > As far as thinking that the proposal is ludicrous --- what precisel=
y
> > did you find ludicrous about it?
>=20
> Mainly the idea that discard requests should act as barriers and inst=
ead
> of fixing that, you propose a lot of complexity to work around it.

I can't fix hardware braindamage.  Given that the standard
specifications is terminally broken, (and we can't really fix it
without getting the drive manufacturers to rip out and replace NCQ
with something sane --- good luck with that) the complexity is pretty
much unaviodable.  Still think my proposal is ludicrous?

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
