From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 10:19:33 -0400
Message-ID: <20120619141933.GC10637@thunk.org>
References: <4FDF9EBE.2030809@shiftmail.org>
 <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Spelic <spelic@shiftmail.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51276 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2FSOTi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 10:19:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19, 2012 at 04:09:48PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> With thin provisioning you'll get totally different file system
> layout than on fully provisioned disk as you push more and more
> writes to your drive. This unfortunately has great impact on
> performance since file systems usually have a lot of optimization on
> where to put data/metadata on the drive and how to read them.
> However in case of thinly provisioned storage those optimization
> would not help. And yes, you just have to expect lower performance
> with dm-thin from the file system on top of it. It is not and it
> will never be ideal solution for workloads where you expect the best
> performance.

One of the things which would be nice to be able to easily set up is a
configuration where we get the benefits of thin provisioning with
respect to snapshost, but where the underlying block device used by
the file system is contiguous.  That is, it would be really useful to
*not* use thin provisioning for the underlying file system, but to use
thin provisioned snapshots.  That way we only pay the thinp
performance penalty for the snapshots, and not for normal file system
operations.  This is something that would be very useful both for ext4
and xfs.

I talked to Alasdair about this a few months ago at the Collab Summit,
and I think it's doable today, but it was somewhat complicaed to set
up.  I don't recall the details now, but perhaps someone who's more
familiar device mapper could outline the details, and perhaps we can
either simplify it or abstract it away in a convenient front-end
script?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
