From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Checking of NULL with __GFP_NOFAIL in kzalloc()
Date: Mon, 2 Mar 2009 11:38:53 +0530
Message-ID: <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
References: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:1270 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCBGI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 01:08:57 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2712814tib.23
        for <linux-ext4@vger.kernel.org>; Sun, 01 Mar 2009 22:08:53 -0800 (PST)
In-Reply-To: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 1, 2009 at 11:35 AM, Manish Katiyar <mkatiyar@gmail.com> wr=
ote:
> Hi,
>
> While going through jbd code, I was wondering why do we need to check
> new_transaction for NULL, if we are passing __GFP_NOFAIL ?
> Last code change around this code was when Ted converted kmalloc to
> kzalloc, but since he also didn't remove it I am guessing there would
> be some good reason for it. Can someone enlighten me ?

I didn't receive any response to this. So probably removing the NULL
check is harmless. Or should I remove the __GFP_NOFAIL flag and keep
the error handling ?

Patches to follow.

Thanks -
Manish

>
> start_this_handle() {
> ..........
> =A0 =A0 =A0 =A0..........
> =A0 =A0 =A0 =A0new_transaction =3D kzalloc(sizeof(*new_transaction),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOFS|__GFP_NOFAIL)=
;
> =A0 =A0 =A0 =A0if (!new_transaction) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0..........
> }
>
>
> Thanks -
> Manish
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
