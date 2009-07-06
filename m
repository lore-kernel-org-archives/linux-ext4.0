From: Xiang Wang <xiangw@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 6 Jul 2009 09:21:25 -0700
Message-ID: <d5ca277e0907060921s72c93834yd98a96cb57809b4b@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
	 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
	 <20090701183130.GA31235@skywalker> <20090706034144.GB31532@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:11457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZGFQV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 12:21:27 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n66GLS31008132
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jul 2009 17:21:28 +0100
Received: from ewy20 (ewy20.prod.google.com [10.241.103.20])
	by spaceape7.eur.corp.google.com with ESMTP id n66GLPIa018887
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jul 2009 09:21:26 -0700
Received: by ewy20 with SMTP id 20so4696183ewy.3
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jul 2009 09:21:25 -0700 (PDT)
In-Reply-To: <20090706034144.GB31532@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 5, 2009 at 8:41 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Thu, Jul 02, 2009 at 12:01:30AM +0530, Aneesh Kumar K.V wrote:
>>
>> I looked at the patch in detail and =A0I guess we should instead for=
ce
>> a data=3Dwriteback mode if the filesystem is created without a journ=
al.
>> I am not sure what whould be the meaning of data=3Dordered/data=3Djo=
urnal
>> without a journal. So if we find that file system doesn't have a jou=
rnal
>> then either we should update the default mount option in the filesys=
tem
>> to be of data=3Dwriteback.
>
> Here's a patch which takes your approach to solving the problem. =A0W=
hat
> do you think?
>
> I haven't messed with dealing with the data=3D mount options in
> fs/ext4/super.c. =A0That's important from a UI point of view, but we
> needed to fix ext4_jbd2.h since it was unconditionally returning 0 if
> there was no journal for all of the ext4_should_*_data() functions.
>
> I believe this should DTRT with the -o nobh mount option, but I'd
> appreciate another pair of eyes taking a look at this.

This patch looks good to us.

In the long run, we still think adding the data=3Dnojournal mount optio=
n
is useful and we are working on this patch.

Thanks,
Xiang

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 - Ted
>
> commit 2a73eff8ba80095a871a6b402dfd24bc454e5bdc
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Sun Jul 5 23:37:13 2009 -0400
>
> =A0 =A0ext4: fix no journal corruption with locale-gen
>
> =A0 =A0If there is no journal, ext4_should_writeback_data() should re=
turn
> =A0 =A0TRUE. =A0This will fix ext4_set_aops() to set ext4_da_ops in t=
he case of
> =A0 =A0delayed allocation; otherwise ext4_journaled_aops gets used by
> =A0 =A0default, which doesn't handle delayed allocation properly.
>
> =A0 =A0The advantage of using ext4_should_writeback_data() approach i=
s that
> =A0 =A0it should handle nobh better as well.
>
> =A0 =A0Thanks to Curt Wohlgemuth for investigating this problem, and =
Aneesh
> =A0 =A0Kumar for suggesting this approach.
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index be2f426..f800134 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -282,7 +282,7 @@ static inline int ext4_should_order_data(struct i=
node *inode)
> =A0static inline int ext4_should_writeback_data(struct inode *inode)
> =A0{
> =A0 =A0 =A0 =A0if (EXT4_JOURNAL(inode) =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> =A0 =A0 =A0 =A0if (!S_ISREG(inode->i_mode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
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
