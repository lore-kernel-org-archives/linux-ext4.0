From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 16:51:45 +0200
Message-ID: <48440901.2050809@bull.net>
References: <48402253.8040407@bull.net> <48406A7D.6020300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47922 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYFBOwH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 10:52:07 -0400
In-Reply-To: <48406A7D.6020300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Valerie, would you be interested in any xfs tuning?  :)
Yes, if you give me inputs.

>=20
> I don't know how much tuning is "fair" for the comparison... but I th=
ink
> in real usage xfs would/should get tuned a bit for a workload like th=
is.
>=20
> At the 5T range xfs gets into a funny allocation mode...

Look at the tests I'd done one year ago:
  http://www.bullopensource.org/ext4/20070404/ffsb-write.html
Large sequential writes were done on a smaller device. With 4 threads,
xfs is better than ext3 and ext4. But when the thread number is increas=
ed,
xfs becomes less good.

To run my tests with 128 threads, maybe I have to tune something in xfs=
=2E

>=20
> If you mount with "-o inode64" I bet you see a lot better performance=
=2E
>=20
> Or, you could do sysctl -w fs.xfs.rotorstep=3D256
>=20
> which would probably help too.
>=20
> with a large fs like this, the allocator gets into a funny mode to ke=
ep
> inodes in the lower part of the fs to keep them under 32 bits, and
> scatters the data allocations around the higher portions of the fs.
>=20
> Either -o inode64 will completely avoid this, or the rotorstep should
> stop it from scattering each file, but instead switching AGs only eve=
ry
> 256 files.
>=20
> Could you also include the xfsprogs version on your summary pages, an=
d
> maybe even the output of xfs_info /mount/point so we can see the full=
 fs
> geometry?  (I'd suggest maybe tune2fs output for the ext[34] filesyst=
ems
> too, for the same reason)
>=20
> When future generations look at the results it'll be nice to have as
> much specificity about the setup as possible, I think.
Yes, I agree. Thank you very much for yours comments. They help me much=
=2E
    Val=E9rie

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
