From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Checking of NULL with __GFP_NOFAIL in kzalloc()
Date: Mon, 2 Mar 2009 13:45:16 +0530
Message-ID: <ea11fea30903020015x4dad07c2pf369a9fbbee9c9cc@mail.gmail.com>
References: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com>
	 <ea11fea30903012208k6992a019h9683b95379314b55@mail.gmail.com>
	 <20090302073521.GI3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:20792 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZCBIPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 03:15:20 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2752490tib.23
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2009 00:15:17 -0800 (PST)
In-Reply-To: <20090302073521.GI3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 2, 2009 at 1:05 PM, Andreas Dilger <adilger@sun.com> wrote:
> On Mar 02, 2009 =A011:38 +0530, Manish Katiyar wrote:
>> On Sun, Mar 1, 2009 at 11:35 AM, Manish Katiyar <mkatiyar@gmail.com>=
 wrote:
>> > While going through jbd code, I was wondering why do we need to ch=
eck
>> > new_transaction for NULL, if we are passing __GFP_NOFAIL ?
>> > Last code change around this code was when Ted converted kmalloc t=
o
>> > kzalloc, but since he also didn't remove it I am guessing there wo=
uld
>> > be some good reason for it. Can someone enlighten me ?
>>
>> I didn't receive any response to this. So probably removing the NULL
>> check is harmless. Or should I remove the __GFP_NOFAIL flag and keep
>> the error handling ?
>
> Neither, please. =A0The NULL check is harmless, and static code check=
ers
> will complain about k[zm]alloc() without a corresponding NULL check.

Ohh... Ok.. Thanks Andreas, I didn't think about static code checkers.
Please ignore the sent patch.

Thanks -
Manish

> Branch prediction will get this right, so the overhead is miniscule.
>
>> > start_this_handle() {
>> > ..........
>> > =A0 =A0 =A0 =A0..........
>> > =A0 =A0 =A0 =A0new_transaction =3D kzalloc(sizeof(*new_transaction=
),
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOFS|__GFP_NOFA=
IL);
>> > =A0 =A0 =A0 =A0if (!new_transaction) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> > =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0..........
>> > }
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
