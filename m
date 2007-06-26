From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: performance testing
Date: Tue, 26 Jun 2007 11:48:46 +0200
Message-ID: <4680E0FE.8080102@bull.net>
References: <467BE4C0.2020203@bull.net>	 <1182541578.9939.3.camel@localhost.localdomain>	 <467C99F5.6060603@clusterfs.com> <1182755567.4067.1.camel@localhost.localdomain> <467FE8A5.4030508@bull.net> <467FEAF7.7060902@clusterfs.com> <4680CE9B.1030602@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>,
	Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60211 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbXFZJrm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 05:47:42 -0400
In-Reply-To: <4680CE9B.1030602@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Clement wrote:
> Alex Tomas wrote:
>> Jean noel Cordenner wrote:
>>> The last patch queue concerns the  2.6.22-rc4 kernel, so we took th=
e
>>> previous ext4 patch queue including the modifications suggested by=20
>>> dmitriy:
>>> http://article.gmane.org/gmane.comp.file-systems.ext4/2291
>>> This solve the oops problem but after a while, the system hangs. We=
 are
>>> still trying to find where the bug is.
>>> When we remove all the patches until booked-page-flag.patch in the
>>> series, the system still hangs. When using another filesystem, or
>>> whithout any patches it works.
>>
>> any details? backtraces? dmesg?
>=20
> We are trying to get some traces, but with 2.6.22-rc5 and 2.6.22-rc6=20
> kernels, the serial console isn't working on our systems (x86_64), th=
e=20
> magic SysRq keys either. Strange...
>=20
> When the system hangs, no messages are logged.
> It seems that the hangs only occur with ext4 FS when applying the=20
> patches of the current git tree.
> We are trying now to find which patch is faulty.
>=20
>    Val=E9rie
>=20

It seems that the faulty patch is "ext4-journal_chksum-2.6.20.patch".
Looking at the patch, I think the following change is not correct:

@@ -116,21 +120,36 @@ static int journal_write_commit_record(j

     bh =3D jh2bh(descriptor);

-   /* AKPM: buglet - add `i' to tmp! */
     for (i =3D 0; i < bh->b_size; i +=3D 512) {
-       journal_header_t *tmp =3D (journal_header_t*)bh->b_data;
+       struct commit_header *tmp =3D (struct commit_header*)bh->b_data=
 +
+                                           i;

Shouldn't it be :

   struct commit_header *tmp =3D (struct commit_header*)(bh->b_data + i=
);

Val=E9rie
