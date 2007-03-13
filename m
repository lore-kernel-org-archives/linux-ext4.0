From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 13 Mar 2007 09:23:28 +0100
Message-ID: <45F65F80.7050202@bull.net>
References: <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070306203952.471218df.akpm@linux-foundation.org> <20070307170955.GA4252@skl-net.de> <20070307114525.08265c33.akpm@linux-foundation.org> <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com> <45F57034.2020402@bull.net> <20070313070134.GK5266@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andre Noll <maan@systemlinux.org>, Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40514 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbXCMIXu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2007 04:23:50 -0400
In-Reply-To: <20070313070134.GK5266@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Mar 12, 2007  16:22 +0100, Valerie Clement wrote:
>> Mingming Cao wrote:
>>> IBM has done some testing (dbench, fsstress, fsx, tiobench, iozone =
etc)
>>> on 10TB ext3, I think RedHat and BULL have done similar test on >8T=
B
>>> ext3 too.
>> Is there not a problem of backward-compatibility with old kernels?
>> Doesn't we need to handle a new INCOMPAT flag in e2fsprogs and kerne=
l
>> before allowing ext3 filesystems greater than 8T?
>=20
> No, it really depends on the kernel.  There were some bugs that cause=
d
> problems with > 8TB because of signed 32-bit int problems, so it isn'=
t
> really recommended to use > 8TB unless you know this is fixed in your
> kernel (and any older kernel you might have to downgrade to).
>=20

OK. Thanks.
As Andre mentions it, it seems that the option "-F" for mkfs is=20
necessary to create an ext3 FS > 8T.
(I've got the same behavior but I didn't apply the latest patches=20
against my current version of e2fsprogs, so I can't check if that has=20
changed since).
Is it the right way?

     Val=E9rie
