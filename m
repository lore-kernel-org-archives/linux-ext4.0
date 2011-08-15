From: Tao Ma <tm@tao.ma>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 10:36:21 +0800
Message-ID: <4E488625.609@tao.ma>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru> <4E48390E.9050102@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:41473 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751560Ab1HOCg1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2011 22:36:27 -0400
In-Reply-To: <4E48390E.9050102@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/15/2011 05:07 AM, Michael Tokarev wrote:
> 15.08.2011 00:57, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> 13.08.2011 20:02, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> Hi Michael,
>>> 	could you please check whether this patch work for you?
>>
>> With this patch applied to 3.0.1 I can't trigger the issue anymore,
>> after several attempts -- the system just works as it shold be.
>> I'm not sure this is the right fix or it's just my testcase isn't
>> as good as it can be... ;)
Thanks for the test.
>=20
> Well, I found a way to trigger data corruption with this patch
> applied.  I guess it's not fault of this patch, but some more
> deep problem instead.
>=20
> The sequence is my usual copy of an oracle database from another
> place and start it.  When oracle starts doing it's direct-I/O
> against its redologs, we had problem which is now solved.  But
> now I do the following: I shutdown the database, rename the current
> redologs out of the way and copy them back into place as new files.
> And start the database again.
>=20
> This time, oracle complains that the redologs contains garbage.
> I can reboot the machine now, and compare old (renamed) redologs
> with copies - they're indeed different.
>=20
> My guess is that copy is done from the pagecache - from the old
> contents of the files, somehow ignoring the (direct) writes
> performed by initial database open.  But that copy is somehow
> damaged now too, since even file identification is now different.
>=20
> Is this new issue something that dioread_nolock supposed to create?
> I mean, it isn't entirely clear what it supposed to do, it looks
> somewhat hackish, but without it performance is quite bad.
So could I generalize your sequence like below:
1. copy a large file to a new ext4 volume
2. do some direct i/o read/write to this file(bs=3D512)
3. rename it.
4. cp this back to the original file
5. do direct i/o read/write(bs=3D512) now and the file is actually corr=
upted.

You used to meet with problem in step 2, and my patch resolved it. Now
you met with problems in step 5. Right?

Thanks
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
