From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: Porting Zfs features to ext2/3
Date: Tue, 29 Jul 2008 21:00:26 +0000 (UTC)
Message-ID: <loom.20080729T202118-289@post.gmane.org>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu> <1217218559.28825.12.camel@telesto> <20080728124055.GD9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47831 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYG2VFE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 17:05:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KNwNS-0000l6-S3
	for linux-ext4@vger.kernel.org; Tue, 29 Jul 2008 21:05:02 +0000
Received: from 81-197-3-72.elisa-mobile.fi ([81.197.3.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 21:05:02 +0000
Received: from szaka by 81-197-3-72.elisa-mobile.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 21:05:02 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso <at> mit.edu> writes:
> On Sun, Jul 27, 2008 at 10:15:59PM -0600, Eric Anopolsky wrote:
> > It's true that ZFS on FUSE performance isn't all it could be right =
now.
> > However, ZFS on FUSE is currently not taking advantage of mechanism=
s
> > FUSE provides to improve performance. For an example of what can be
> > achieved, check out http://www.ntfs-3g.org/performance.html .
>=20
> Yes... and take a look at the metadata operations numbers. =20

Those are old numbers of the unoptimized ntfs-3g driver, which could be=
=20
at least 3-30 times better.

- create: until recently, when ext3 defaulted htree, the unoptimized=20
ntfs-3g was 2-4x faster. But nobody seems to really care because it's=20
not a real-world benchmark (creation of 0 byte size files).

- lookup: by enabling FUSE entry cache the performance will be exactly=20
the same (no user space involvement), or the bottleneck will be the=20
disk seek time and how an fs optimizes for it.=20

> FUSE can do things to accellerate bulk read/write,=20

=46USE can also cache attributes, positive/negative lookups, file data
and hopefully the new performance improving features, infrastructure=20
being worked on will be added in the future too.=20

> but metadata-intensive operations will (I suspect) always be slow. =20

Basically FUSE file systems can be considered as in-kernel network=20
file systems where the network latency is a context switch. Yes,
things need to be done a bit differently sometimes but achieving
high-performance even for metadata operations is not impossible.

> I also question whether
> the FUSE implementation will have the safety that has always been the
> Raison d'=C3=AAtre of ZFS.  Have you or the ZFS/FUSE developers done =
tests
> where you are writing to the filesystem, and then someone pulls the
> plug on the fileserver while ZFS is writing?  Does the filesystem
> recovery cleanly from such a scenario?

This is an implementation detail, irrelevant to FUSE.=20

Regards,  Szaka

--
NTFS-3G: http://ntfs-3g.org



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
