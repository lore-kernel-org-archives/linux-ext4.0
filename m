From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 13:03:12 +0400
Message-ID: <4E48E0D0.3090005@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru> <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma> <4E48D231.5060807@msgid.tls.msk.ru> <4E48DF31.4050603@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:34862 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1HOJDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 05:03:14 -0400
In-Reply-To: <4E48DF31.4050603@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

15.08.2011 12:56, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 15.08.2011 12:00, Michael Tokarev wrote:
> [....]
>=20
> So, it looks like this (starting with cold cache):
>=20
> 1. rename the redologs and copy them over - this will
>    make a hot copy of redologs
> 2. startup oracle - it will complain that the redologs aren't
>    redologs, the header is corrupt
> 3. shut down oracle, start it up again - it will succeed.
>=20
> If between 1 and 2 you'll issue sync(1) everything will work.
> When shutting down, oracle calls fsync(), so that's like
> sync(1) again.
>=20
> If there will be some time between 1. and 2., everything
> will work too.
>=20
> Without dioread_nolock I can't trigger the problem no matter
> how I tried.
>=20
>=20
> A smaller test case.  I used redo1.odf file (one of the
> redologs) as a test file, any will work.
>=20
>  $ cp -p redo1.odf temp
>  $ dd if=3Dtemp of=3Dfoo iflag=3Ddirect count=3D20
>=20
> Now, first 512bytes of "foo" will contain all zeros, while
> the beginning of redo1.odf is _not_ zeros.
>=20
> Again, without aioread_nolock it works as expected.
>=20
>=20
> And the most important note: without the patch there's no
> data corruption like that.  But instead, there is the
> lockup... ;)

Actually I can reproduce this data corruption without the
patch too, just not that easily.  Oracle testcase (with
copying redologs over) does that nicely.  So that's a
separate bug which was here before.

> Thank you,
>=20
> /mjt

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
