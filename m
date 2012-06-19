From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 09:23:33 -0500
Message-ID: <4FE08B65.70303@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com> <20120619141933.GC10637@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	Spelic <spelic@shiftmail.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2FSOXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 10:23:48 -0400
In-Reply-To: <20120619141933.GC10637@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/19/12 9:19 AM, Ted Ts'o wrote:
> On Tue, Jun 19, 2012 at 04:09:48PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
>>
>> With thin provisioning you'll get totally different file system
>> layout than on fully provisioned disk as you push more and more
>> writes to your drive. This unfortunately has great impact on
>> performance since file systems usually have a lot of optimization on
>> where to put data/metadata on the drive and how to read them.
>> However in case of thinly provisioned storage those optimization
>> would not help. And yes, you just have to expect lower performance
>> with dm-thin from the file system on top of it. It is not and it
>> will never be ideal solution for workloads where you expect the best
>> performance.
>=20
> One of the things which would be nice to be able to easily set up is =
a
> configuration where we get the benefits of thin provisioning with
> respect to snapshost, but where the underlying block device used by
> the file system is contiguous.  That is, it would be really useful to
> *not* use thin provisioning for the underlying file system, but to us=
e
> thin provisioned snapshots.  That way we only pay the thinp
> performance penalty for the snapshots, and not for normal file system
> operations.  This is something that would be very useful both for ext=
4
> and xfs.

I agree, and have asked for exactly the same thing... though I have no
idea how hard it is to disentangle allocation-aware snapshots from thin=
g
provisioned storage.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
