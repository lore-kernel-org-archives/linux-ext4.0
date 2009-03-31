From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?=
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Tue, 31 Mar 2009 13:33:57 +0900
Message-ID: <49D19D35.7020407@oss.ntt.co.jp>
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu> <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es> <20090330142518.GI13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	=?ISO-8859-1?Q?Fernando_Luis_V=E1zq?= =?ISO-8859-1?Q?uez_Cao?=
	<flvazquez@uvigo.es>, Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57874 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZCaEd7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 00:33:59 -0400
In-Reply-To: <20090330142518.GI13356@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Mar 30, 2009 at 10:01:16PM +0900, Fernando Luis V=E1zquez Cao=
 wrote:
>> Chris, I have just sent patches that attempt to fix both ext3 and
>> ext4 while also adding a per-device sysfs knob tu disable
>> write-flushes. A previous version of this patch set added a new
>> generic mount option but comments from Christoph and others
>> convinced me to turn it into a per-device tunable. Could you take
>> a look at the patches?
>=20
> Fernando, see my comments on those patches.  We don't need to issue a
> barrier after a call to sync_inode() or ext[34]_force_commit(), since
> those functions will issue a barrier for us.  It would probably be a
> good idea to use blktrace to test and make sure that we have one and
> exactly one barrier op issued for each fsync().

I'll give blktrace a spin and check if things are working as expected.

Thanks!

- Fernando
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
