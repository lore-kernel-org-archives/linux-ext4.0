From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 01:07:26 +0400
Message-ID: <4E48390E.9050102@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:57466 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HNVH2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2011 17:07:28 -0400
In-Reply-To: <4E4836A8.3080709@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

15.08.2011 00:57, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 13.08.2011 20:02, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Hi Michael,
>> 	could you please check whether this patch work for you?
>=20
> With this patch applied to 3.0.1 I can't trigger the issue anymore,
> after several attempts -- the system just works as it shold be.
> I'm not sure this is the right fix or it's just my testcase isn't
> as good as it can be... ;)

Well, I found a way to trigger data corruption with this patch
applied.  I guess it's not fault of this patch, but some more
deep problem instead.

The sequence is my usual copy of an oracle database from another
place and start it.  When oracle starts doing it's direct-I/O
against its redologs, we had problem which is now solved.  But
now I do the following: I shutdown the database, rename the current
redologs out of the way and copy them back into place as new files.
And start the database again.

This time, oracle complains that the redologs contains garbage.
I can reboot the machine now, and compare old (renamed) redologs
with copies - they're indeed different.

My guess is that copy is done from the pagecache - from the old
contents of the files, somehow ignoring the (direct) writes
performed by initial database open.  But that copy is somehow
damaged now too, since even file identification is now different.

Is this new issue something that dioread_nolock supposed to create?
I mean, it isn't entirely clear what it supposed to do, it looks
somewhat hackish, but without it performance is quite bad.

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
