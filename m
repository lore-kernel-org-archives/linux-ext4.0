From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 16:53:34 -0700
Message-ID: <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
References: <4E456436.8070107@msgid.tls.msk.ru>
	<1313251371-3672-1-git-send-email-tm@tao.ma>
	<4E4836A8.3080709@msgid.tls.msk.ru>
	<4E48390E.9050102@msgid.tls.msk.ru>
	<4E488625.609@tao.ma>
	<4E48D231.5060807@msgid.tls.msk.ru>
	<4E48DF31.4050603@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:17602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1HOXxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Aug 2011 19:53:38 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id p7FNra6w020236
	for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 16:53:36 -0700
Received: from gwj17 (gwj17.prod.google.com [10.200.10.17])
	by wpaz17.hot.corp.google.com with ESMTP id p7FNqtQ0025987
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 16:53:35 -0700
Received: by gwj17 with SMTP id 17so4355244gwj.24
        for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 16:53:34 -0700 (PDT)
In-Reply-To: <4E48DF31.4050603@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Michael,

On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> 15.08.2011 12:00, Michael Tokarev wrote:
> [....]
>
> So, it looks like this (starting with cold cache):
>
> 1. rename the redologs and copy them over - this will
> =A0 make a hot copy of redologs
> 2. startup oracle - it will complain that the redologs aren't
> =A0 redologs, the header is corrupt
> 3. shut down oracle, start it up again - it will succeed.
>
> If between 1 and 2 you'll issue sync(1) everything will work.
> When shutting down, oracle calls fsync(), so that's like
> sync(1) again.
>
> If there will be some time between 1. and 2., everything
> will work too.
>
> Without dioread_nolock I can't trigger the problem no matter
> how I tried.
>
>
> A smaller test case. =A0I used redo1.odf file (one of the
> redologs) as a test file, any will work.
>
> =A0$ cp -p redo1.odf temp
> =A0$ dd if=3Dtemp of=3Dfoo iflag=3Ddirect count=3D20
Isn't this the expected behavior here? When doing
'cp -p redo1.odf temp', data is copied to temp through
buffer write, but there is no guarantee when data will be
actually written to disk. Then with 'dd if=3Dtemp of=3Dfoo
iflag=3Ddirect count=3D20', data is read directly from disk.
Very likely, the written data hasn't been flushed to disk
yet so ext4 returns zero in this case.

Jiaying
>
> Now, first 512bytes of "foo" will contain all zeros, while
> the beginning of redo1.odf is _not_ zeros.
>
> Again, without aioread_nolock it works as expected.
>
>
> And the most important note: without the patch there's no
> data corruption like that. =A0But instead, there is the
> lockup... ;)
>
> Thank you,
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
