From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] add aio/dio regression test race between write and fcntl V2
Date: Tue, 14 Oct 2014 18:06:26 +0400
Message-ID: <87iojmpwyl.fsf@openvz.org>
References: <1412866642-25191-1-git-send-email-dmonakhov@openvz.org> <20141014051151.GK5267@dastard>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44142 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbaJNOGf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2014 10:06:35 -0400
In-Reply-To: <20141014051151.GK5267@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Oct 09, 2014 at 06:57:22PM +0400, Dmitry Monakhov wrote:
>> Original report: https://lkml.org/lkml/2014/10/8/545
>> perform AIO-DIO and fcntl(F_SETFL) concurently
>> Unaligned AIO likely result in synchronization which makes racewindow wi=
der.
>>=20
>> changes from v1->v2
>>  - Properly reuse aio context
>
> Couple of things below....
>
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  src/aio-dio-regress/aio-dio-fcntl-race.c |  148 +++++++++++++++++++++++=
+++++++
>>  tests/generic/326                        |   51 ++++++++++
>>  tests/generic/326.out                    |    2 +
>>  tests/generic/group                      |    1 +
>>  4 files changed, 202 insertions(+), 0 deletions(-)
>>  create mode 100644 src/aio-dio-regress/aio-dio-fcntl-race.c
>>  create mode 100755 tests/generic/326
>>  create mode 100644 tests/generic/326.out
>>=20
>> diff --git a/src/aio-dio-regress/aio-dio-fcntl-race.c b/src/aio-dio-regr=
ess/aio-dio-fcntl-race.c
>> new file mode 100644
>> index 0000000..835dbdf
>> --- /dev/null
>> +++ b/src/aio-dio-regress/aio-dio-fcntl-race.c
>> @@ -0,0 +1,148 @@
>> +/*
>> + * Perform aio writes to file and toggle O_DIRECT flag concurrently
>> + * this may trigger race between file->f_flags read and modification
>> + * unuligned aio allow to makes race window wider.
>> + * Regression test for https://lkml.org/lkml/2014/10/8/545
>> + *
>> + * Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
>
> YOu must have copied the code from somewhere. Can you add a note to
> say where it came from in the patch description? And if you added
> any significant modifications, you should add your own copyright to
> it as well...
>
>> diff --git a/tests/generic/326 b/tests/generic/326
>> new file mode 100755
>> index 0000000..8975a91
>> --- /dev/null
>> +++ b/tests/generic/326
>> @@ -0,0 +1,51 @@
>> +#! /bin/bash
>> +# FS QA Test No. 326
>
> Can you rename this to the first unused generic test?
Ok. I thought that I should use latest_used+1.
And copy-paste other aio-dio test.
I've fixed './new' script according to your comments and regenerated the te=
st
Please find updated version in your mbox
Message-Id: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org>
Message-Id: <1413295189-28530-2-git-send-email-dmonakhov@openvz.org>
>
>> +# Run aio-dio-fcntl-race - test aio write race with O_DIRECT toggle
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2009 Dmitry Monakhov.  All Rights Reserved.
>
> 2009 doesn't seem right for a test that was just written...

>
> Cheers,
>
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPS3iAAoJEFzOBSYIXfvet6kP/3Z/+PCGy4TeINjOaLwEDUIH
on6gF0QFH9GKwmydGuWX9wqirRAjEu63QVVwbDngYgbyCYz3Xhf0WtbJSxyJTKlU
BGsOUi1qdA0kALSf7jVtItaZGo5p3lU17P8aXD1y0qSFC0czBZvxw5TPNJ5mF/XK
YdQ8wGvqFP3sM4Ttz0chu1HiHFLkhi2H9cPoep7Ub0JNsSrcRST2Pjlq6VE674iD
jJpvt1BQXxHekV9KTManZPAOKxca6dnybrZnpr69wQaT9puVmoqUMcDhZcAR63oY
crx/sdBbKFD2ks7BiMuHcHiFVkLnxqr3O17454YhYcdRCPSKRRLOKY86BM3f/naq
sTORPb4MoAEuq3oo/5d8JQuvxGM61jTa+RWm7lyOhXDKNqy57/zweBzWI4hRTOlX
WWqy5ryywNar0BUFBMIPQ+5W8NoE3cvMZOdmL/ISGcSPwybXud6rL8JeE7uuAMQV
FJlnipD3c5ycX4xkn7cplKqjIJ3L0SnK9vY95G9BSOxmHpt0KRhCSajTL5f8ikmH
PvcyAZNeF42iX0FF0pEEMY+L0+BrlLlsGGuzH74S5AuWaQZs6kSqnsXqpDEf4Ipg
x5y5uNo5yutGiXkEnobLhutU7IbY0PBGnQ0s06UOAMREF39crZ/0wPh4MmCFDSj6
50zE9WC1hBpQKzasFmH7
=tUqT
-----END PGP SIGNATURE-----
--=-=-=--
