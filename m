From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Tue, 31 Mar 2009 13:28:33 +0900
Message-ID: <49D19BF1.6020305@oss.ntt.co.jp>
References: <200903291928.14451.bzolnier@gmail.com>	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>	 <49D03AE1.8070009@redhat.com>	 <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es> <1238419459.30488.42.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=
	<flvazquez@uvigo.es>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57706 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZCaE2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 00:28:35 -0400
In-Reply-To: <1238419459.30488.42.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason wrote:
> On Mon, 2009-03-30 at 22:01 +0900, Fernando Luis V=C3=A1zquez Cao wro=
te:
>> Chris Mason wrote:
>>> On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
>>>> Theodore Tso wrote:
>>>>> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
>>>>>> As long as we keep the call there this is probably good, but aft=
er
>>>>>> talking w/ Chris Mason, I think the call is extraneous anyway an=
d should
>>>>>> probably just be removed...
>>>>>>
>>>>> Yes, I agree, but it takes a lot of digging to be completely sure=
 of
>>>>> that it's safe to remove it.  Interestingly, it was you who added=
 the
>>>>> patch which added the call to blkdev_issue_flush():
>>>>> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
>>>>> Author: Eric Sandeen <sandeen@redhat.com>
>>>>> Date:   Fri Jul 11 19:27:31 2008 -0400
>>>> Yes, it was.  Although I got the idea when hch pointed out that Su=
SE did
>>>> this... thanks to Chris.  It's come full circle.  :)
>>> Grin.  I'm not sure the I_DIRTY checks alone are enough to decide t=
hat a
>>> commit is required though.  I think the inode could be clean but st=
ill
>>> have metadata that needs commit.
>> Chris, I have just sent patches that attempt to fix both ext3 and
>> ext4 while also adding a per-device sysfs knob tu disable
>> write-flushes. A previous version of this patch set added a new
>> generic mount option but comments from Christoph and others
>> convinced me to turn it into a per-device tunable. Could you take
>> a look at the patches?
>>
>=20
> Jens' comment are right on I think.  If we get that fixed up we can g=
et
> rid of all the filesystem mount -o barrier=3Dflush,0,1,xyz confusion =
and
> set it via the block devices directly.
>=20
> That would be nice ;)

Thank you for your feedback, Chris! I will address some of the issues s=
potted
in the mailing list and resend the whole patch-set.

Regards,

=46ernando
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
