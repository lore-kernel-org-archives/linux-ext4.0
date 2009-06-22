From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 22 Jun 2009 10:01:39 -0700
Message-ID: <6601abe90906221001u15f370e6vcb36a02d54d2f8c3@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
	 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
	 <20090622165626.GB26149@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:18651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZFVRBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 13:01:43 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id n5MH1hLc011695
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 18:01:43 +0100
Received: from pzk30 (pzk30.prod.google.com [10.243.19.158])
	by wpaz5.hot.corp.google.com with ESMTP id n5MH1eO6031693
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:01:40 -0700
Received: by pzk30 with SMTP id 30so3031950pzk.18
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:01:40 -0700 (PDT)
In-Reply-To: <20090622165626.GB26149@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2009 at 9:56 AM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Mon, Jun 22, 2009 at 09:42:25AM -0700, Curt Wohlgemuth wrote:
>> Hi Ted:
>>
>> I think the following patch is sufficient. =A0It explicitly sets the=
 aops to
>> ext4_writeback_aops if there is no delayed allocation and no journal=
=2E
>>
>> I tested the locale-gen example with all combinations of
>>
>> =A0 =A0data=3Dwriteback
>> =A0 =A0data=3Dordered
>> =A0 =A0data=3Djournal
>> =A0 =A0<no journal at all>
>>
>> and
>>
>> =A0 =A0delalloc
>> =A0 =A0nodelalloc
>>
>> and it works correctly now. =A0The paths for writeback seem fine to =
me for an
>> inode w/o a journal.
>>
>>
>> =A0 =A0 =A0 =A0Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>> ---
>> --- 2.6.26/fs/ext4/inode.c.orig =A0 =A0 =A0 2009-06-09 20:05:27.0000=
00000 -0700
>> +++ 2.6.26/fs/ext4/inode.c =A0 =A02009-06-22 08:55:13.000000000 -070=
0
>> @@ -3442,15 +3442,12 @@ static const struct address_space_operat
>>
>> =A0void ext4_set_aops(struct inode *inode)
>> =A0{
>> - =A0 =A0 if (ext4_should_order_data(inode) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 test_opt(inode->i_sb, DELALLOC))
>> + =A0 =A0 if (test_opt(inode->i_sb, DELALLOC))
>
> This change is not related to the fix right ?
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_da_aop=
s;
>> =A0 =A0 =A0 else if (ext4_should_order_data(inode))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_ordere=
d_aops;
>> - =A0 =A0 else if (ext4_should_writeback_data(inode) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0test_opt(inode->i_sb, DELALLOC))
>> - =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_da_aops;
>> - =A0 =A0 else if (ext4_should_writeback_data(inode))
>> + =A0 =A0 else if (ext4_should_writeback_data(inode) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_JO=
URNAL(inode) =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_writeb=
ack_aops;
>
> Can you send a patch with this hunk alone. The previous one is not
> related to the fix right ?

You need them both.  We want all inodes with delayed allocation to use
ext4_da_aops.  The fall-through cases are just for nodelalloc.

Curt

>
>
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->a_ops =3D &ext4_journa=
lled_aops;
>>
>>
>
> -aneesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
