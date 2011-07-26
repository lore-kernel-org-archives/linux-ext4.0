From: Aditya Kali <adityakali@google.com>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 11:48:44 -0700
Message-ID: <CAGr1F2Hs1e=tsY7v5-hOTVEE_2PVyTFB06ZP_TpEcFV+mdG_Ww@mail.gmail.com>
References: <20110725155836.GF6107@quack.suse.cz> <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
 <20110726121225.GC20131@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1GZStH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 14:49:07 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p6QIn6uc027641
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 11:49:06 -0700
Received: from qyk30 (qyk30.prod.google.com [10.241.83.158])
	by wpaz21.hot.corp.google.com with ESMTP id p6QImLsM029682
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 11:49:05 -0700
Received: by qyk30 with SMTP id 30so1918088qyk.13
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 11:49:05 -0700 (PDT)
In-Reply-To: <20110726121225.GC20131@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 5:12 AM, Jan Kara <jack@suse.cz> wrote:
> =C2=A0Hi Yongqiang,
>
> On Tue 26-07-11 09:20:28, Yongqiang Yang wrote:
>> I have been thinking if we can handle fiemap much simpler for a whil=
e.
>> =C2=A0Current code is very ugly due to page cache look up. =C2=A0I h=
ave a
>> thought on simplifying these code. =C2=A0The reason leading us to lo=
oking
>> up page cache is that delayed extents are not in extents tree. =C2=A0=
I
>> think we can add an in-memory delayed extents list in inode, and we
>> can delete entries in the list after we allocate blocks for them.
>> There is no limit on length of extents in the list, this way can an
>> entry contain as many blocks as they are contiguous logically.
>>
>> What's your opinion?
> =C2=A0Yes, that should be doable and shouldn't have too big overhead.=
 It's just
> stupid we'll do all this stuff only for fiemap call which is relative=
ly
> rare.
>
Delayed extents lookup will also help resolve another race that we
currently have in bigalloc code path. Here, we need to figure out if a
cluster is already under delayed allocation or not (to determine
whether we need to reserve quota for this cluster). But, determining
this races against the writeback of delayed allocated pages.
ext4_find_delalloc_range() function has a comment about this race. If
there is a delayed extents list and the extents are removed from his
list when they are actually mapped, then ext4_find_delalloc_range()
can simply check against this list.


> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>
>> On Mon, Jul 25, 2011 at 11:58 PM, Jan Kara <jack@suse.cz> wrote:
>> > =C2=A0Hello,
>> >
>> > =C2=A0I just had a look at the code checking delayed allocated buf=
fers in
>> > ext4_ext_fiemap_cb(). I believe the checks there could use some el=
imiation
>> > of common patterns but that's just a minor thing. The main problem=
 is that
>> > the code can easily crash the kernel when it races with page recla=
im. You
>> > just cannot access most of the page contents (and for buffers it i=
s
>> > especially true) without locking the page. Getting a reference via
>> > find_get_pages_tag() guarantees you the structure cannot go away b=
ut mm is
>> > still free to detach the page from the mapping at any moment. So y=
ou must
>> > always lock a page and check that it still belongs to the desired =
mapping
>> > before you check 'page_has_buffers()'.
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0Honza
>> > --
>> > Jan Kara <jack@suse.cz>
>> > SUSE Labs, CR
>> >
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
