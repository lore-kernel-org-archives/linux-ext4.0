From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 29 Jun 2009 10:50:26 -0700
Message-ID: <6601abe90906291050s4bc268b2mca1f2addb45fddb1@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
	 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:40111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZF2Ru2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 13:50:28 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id n5THoTIQ012431
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 18:50:29 +0100
Received: from wf-out-1314.google.com (wfa28.prod.google.com [10.142.1.28])
	by wpaz33.hot.corp.google.com with ESMTP id n5THoQYW020823
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 10:50:27 -0700
Received: by wf-out-1314.google.com with SMTP id 28so885989wfa.29
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 10:50:26 -0700 (PDT)
In-Reply-To: <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, did you have any comment or objections to this patch?

Thanks,
Curt


On Mon, Jun 22, 2009 at 9:42 AM, Curt Wohlgemuth<curtw@google.com> wrot=
e:
> Hi Ted:
>
> I think the following patch is sufficient. =A0It explicitly sets the =
aops to
> ext4_writeback_aops if there is no delayed allocation and no journal.
>
> I tested the locale-gen example with all combinations of
>
> =A0 data=3Dwriteback
> =A0 data=3Dordered
> =A0 data=3Djournal
> =A0 <no journal at all>
>
> and
>
> =A0 delalloc
> =A0 nodelalloc
>
> and it works correctly now. =A0The paths for writeback seem fine to m=
e for an
> inode w/o a journal.
>
>
> =A0 =A0 =A0 Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> --- 2.6.26/fs/ext4/inode.c.orig 2009-06-09 20:05:27.000000000 -0700
> +++ 2.6.26/fs/ext4/inode.c =A0 =A0 =A02009-06-22 08:55:13.000000000 -=
0700
> @@ -3442,15 +3442,12 @@ static const struct address_space_operat
>
> =A0void ext4_set_aops(struct inode *inode)
> =A0{
> - =A0 =A0 =A0 if (ext4_should_order_data(inode) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_opt(inode->i_sb, DELALLOC))
> + =A0 =A0 =A0 if (test_opt(inode->i_sb, DELALLOC))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mapping->a_ops =3D &ext4_da_a=
ops;
> =A0 =A0 =A0 =A0else if (ext4_should_order_data(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mapping->a_ops =3D &ext4_orde=
red_aops;
> - =A0 =A0 =A0 else if (ext4_should_writeback_data(inode) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0test_opt(inode->i_sb, DELALLOC))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_da_ao=
ps;
> - =A0 =A0 =A0 else if (ext4_should_writeback_data(inode))
> + =A0 =A0 =A0 else if (ext4_should_writeback_data(inode) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4=
_JOURNAL(inode) =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mapping->a_ops =3D &ext4_writ=
eback_aops;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mapping->a_ops =3D &ext4_jour=
nalled_aops;
>
>
> On Wed, Jun 17, 2009 at 4:46 PM, Theodore Tso<tytso@mit.edu> wrote:
>> Hi Curt,
>>
>> Thanks for your analysis of the bug. =A0The reason for the strange l=
ogic
>> in ext4_set_aops() is because at the moment the code doesn't support
>> the combination of data=3Djournalled && delalloc. =A0That's why it w=
as
>> explicitly checking for ext4_should_order_data() and
>> ext4_should_writeback_data().
>>
>> We have a check for this in ext4_fill_super(), so your patch should =
be
>> safe, since the combination of ext4_should_journal_data &&
>> test_opt(inode->i_sb, DELALLOC) should never happen.
>>
>> As to your question of whether the nodelalloc and nojournal case
>> should really be ext4_journalled_aops, I suspect ext4_writeback_aops
>> makes more sense. =A0I haven't audited all of the code paths to make
>> sure they DTRT in the non-journalled case yet, though.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
