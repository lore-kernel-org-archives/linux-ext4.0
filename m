From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Mon, 12 Mar 2007 16:22:28 +0100
Message-ID: <45F57034.2020402@bull.net>
References: <20070226133153.GC4095@skl-net.de>	 <20070226182617.GC9968@andrew-vasquezs-computer.local>	 <20070227101100.GA22572@skl-net.de>	 <20070227185134.GJ20397@andrew-vasquezs-computer.local>	 <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de>	 <20070306203952.471218df.akpm@linux-foundation.org>	 <20070307170955.GA4252@skl-net.de>	 <20070307114525.08265c33.akpm@linux-foundation.org> <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andre Noll <maan@systemlinux.org>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57222 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370AbXCLPWu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2007 11:22:50 -0400
In-Reply-To: <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
> On Wed, 2007-03-07 at 11:45 -0800, Andrew Morton wrote:
>> On Wed, 7 Mar 2007 18:09:55 +0100 Andre Noll <maan@systemlinux.org> =
wrote:
>>
>>> On 20:39, Andrew Morton wrote:
>>>> On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.or=
g> wrote:
>>>>
>>> BTW: Are ext3 filesystem sizes greater than 8T now officially
>>> supported?
>> I think so, but I don't know how much 16TB testing developers and
>> distros are doing - perhaps the linux-ext4 denizens can tell us?
>> -
>=20
> IBM has done some testing (dbench, fsstress, fsx, tiobench, iozone et=
c)
> on 10TB ext3, I think RedHat and BULL have done similar test on >8TB
> ext3 too.
>=20
> Mingming

Is there not a problem of backward-compatibility with old kernels?
Doesn't we need to handle a new INCOMPAT flag in e2fsprogs and kernel
before allowing ext3 filesystems greater than 8T?

    Val=E9rie
