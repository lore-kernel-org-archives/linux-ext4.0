From: Andreas Dilger <adilger@sun.com>
Subject: Re: Checking of NULL with __GFP_NOFAIL in kzalloc()
Date: Mon, 02 Mar 2009 00:35:21 -0700
Message-ID: <20090302073521.GI3199@webber.adilger.int>
References: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com>
 <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65477 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZCBHfr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 02:35:47 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n227ZWHZ012439
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 23:35:45 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFV00I00BP1GV00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 01 Mar 2009 23:35:32 -0800 (PST)
In-reply-to: <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 02, 2009  11:38 +0530, Manish Katiyar wrote:
> On Sun, Mar 1, 2009 at 11:35 AM, Manish Katiyar <mkatiyar@gmail.com> =
wrote:
> > While going through jbd code, I was wondering why do we need to che=
ck
> > new_transaction for NULL, if we are passing __GFP_NOFAIL ?
> > Last code change around this code was when Ted converted kmalloc to
> > kzalloc, but since he also didn't remove it I am guessing there wou=
ld
> > be some good reason for it. Can someone enlighten me ?
>=20
> I didn't receive any response to this. So probably removing the NULL
> check is harmless. Or should I remove the __GFP_NOFAIL flag and keep
> the error handling ?

Neither, please.  The NULL check is harmless, and static code checkers
will complain about k[zm]alloc() without a corresponding NULL check.
Branch prediction will get this right, so the overhead is miniscule.

> > start_this_handle() {
> > ..........
> > =A0 =A0 =A0 =A0..........
> > =A0 =A0 =A0 =A0new_transaction =3D kzalloc(sizeof(*new_transaction)=
,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOFS|__GFP_NOFAI=
L);
> > =A0 =A0 =A0 =A0if (!new_transaction) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0..........
> > }

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
