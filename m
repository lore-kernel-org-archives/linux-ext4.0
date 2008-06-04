From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Wed, 04 Jun 2008 17:34:17 +0200
Message-ID: <4846B5F9.8050906@bull.net>
References: <48402253.8040407@bull.net> <4841A871.3020500@redhat.com> <4844B71F.3070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32828 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYFDPel (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 11:34:41 -0400
In-Reply-To: <4844B71F.3070906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Valerie Clement wrote:
>>> Hi all,
>>>
>>> Since a couple of weeks, I did batches of tests to have some perfor=
mance
>>> numbers for the new ext4 features like uninit_groups, flex_bg or
>>> journal_checksum on a 5TB filesystem.
>>> I tried to test allmost all combinations of mkfs and mount options,=
 but
>>> I put only a subset of them in the result tables, the most signific=
ant
>>> for me.
>>>
>>> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got=
 several
>>> hangs and crashes occuring randomly outside ext4, sometimes in the =
slab
>>> code or in the scsi driver eg., and which were not reproductible.
>>> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
>>>
>>> The first results and the test description are available here:
>>> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.h=
tml
>>> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-r=
c2.html
>>>
>> One other question on the tests; am I reading correctly that ext3 us=
ed
>> "data=3Dwriteback" but ext4 used the default data=3Dordered mode?
>=20
> I was interested in the results, especially since ext3 seemed to pret=
ty
> well match ext4 for throughput, although the cpu utilization differed=
=2E
>=20
> I re-ran the same ffsb profiles on an 8G, 4-way opteron box, connecte=
d
> to a "Vendor: WINSYS   Model: SF2372" 2T hardware raid array with 512=
MB
> cache, connected via fibrechannel.
>=20
> Reads go pretty fast:
>=20
> # dd if=3D/dev/sdc bs=3D16M count=3D512 iflag=3Ddirect of=3D/dev/null
> 8589934592 bytes (8.6 GB) copied, 23.2257 seconds, 370 MB/s
>=20
> I got some different numbers....
>=20
> This was with e2fsprogs-1.39 for ext3, e2fsprogs-1.40.10 for ext4, an=
d
> xfsprogs-2.9.8 for xfs.
I was using xfsprogs-2.9.0, maybe too old version...
I'm updating them and I'll run my tests again.

>=20
> I used defaults except; data=3Dwriteback for ext[34] and the nobarrie=
r
> option for xfs.  ext3 was made with 128 byte inodes, ext4 with 256-by=
te
> (new default).  XFS used stock mkfs.  I formatted the entire block
> device /dev/sdc.
>=20
> For the large file write test:
>=20
> 	MB/s	CPU %
> ext3	140	 90.7
> ext4	182	 50.2
> xfs	222	145.0
>=20
> And for the small random readwrite test:
>=20
> 	trans/s	CPU %
> ext3	 9830	 12.2
> ext4	11996	 18.1
> xfs	13863	 23.5
>=20
> Not sure what the difference is ...
>=20
> If you have your tests scripted up I'd be interested to run all the
> variations on this hardware as well, as it seems to show more through=
put
> differences...

I added a link to the scripts I used in the test description section in=
:
http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.h=
tml

   Val=E9rie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
