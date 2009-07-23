From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Fallocate and DirectIO
Date: Thu, 23 Jul 2009 08:56:31 -0700
Message-ID: <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu>
	 <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:41099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZGWP4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 11:56:35 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n6NFuYSn006750
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 08:56:35 -0700
Received: from pzk7 (pzk7.prod.google.com [10.243.19.135])
	by wpaz24.hot.corp.google.com with ESMTP id n6NFuQIP012500
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 08:56:32 -0700
Received: by pzk7 with SMTP id 7so737602pzk.0
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 08:56:31 -0700 (PDT)
In-Reply-To: <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 21, 2009 at 6:27 PM, Curt Wohlgemuth<curtw@google.com> wrot=
e:
> I spent a bit of time looking at this today.
>
> On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> wrote:
>> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrote:
>>> Hi,
>>>
>>> I noticed yesterday that a write to fallocate
>>> space via directIO results in fallback to buffer_IO. ie the userspa=
ce
>>> pages get copied to the page cache and then call a sync.
>>>
>>> I guess this defeat the purpose of using directIO. May be we should
>>> consider this a high priority bug.
>
> My simple experiment -- without a journal -- shows that you're
> observation is correct. =A0*Except* if FALLOC_FL_KEEP_SIZE is used in
> the fallocate() call, in which case the page cache is *not* used.
>
> Pseudo-code example:
>
> =A0open(O_DIRECT)
> =A0fallocate(mode, 512MB)
> =A0while (! written 100MB)
> =A0 =A0 write(64K)
> =A0close()
>
> If mode =3D=3D FALLOC_FL_KEEP_SIZE, then no page cache is used.
> Otherwise, we *do* go through the page cache.
>
> It comes down to the fact that, since the i_size is not updated with
> KEEP_SIZE, then ext4_get_block() is called with create =3D 1, since t=
he
> block that's needed is "beyond" the file end.

Ted, given your concerns over the performance impact of updating the
extents during direct I/O writes, it would seem that the fact that
when KEEP_SIZE is specified we do the DMA (and don't go through the
page cache) would be a problem/bug.  At least, it seems that the
performance issue is the same regardless of whether KEEP_SIZE is used
on the fallocate or not: in both we're dealing with an uninitialized
extent.  Do you agree?

I'm exploring (a) what this performance penalty is for the journal
commit; and (b) can we at least avoid the page cache if your
conditions above (no journal commit; no new extent blocks) are met.

Curt

>
>>
>> I agree that many of users of fallocate() feature (i.e. databases) a=
re
>> going to consider this to be a major misfeature.
>
>>
>> There's going to be a major performance hit though --- O_DIRECT is
>> supposed to be synchronous if all of the alignment requirements are
>> met, which means that by the time the write(2) system call returns,
>> the data is guaranteed to be on disk. =A0But if we need to manipulat=
e
>> the extent tree to indicate that the block is now in use (so the dat=
a
>> is actually accessible), do we force a synchronous journal commit or
>> not? =A0If we don't, then a crash right after an O_DIRECT right into=
 an
>> uninitialized region will cause the data to be "lost" (or at least,
>> unavailable via the read/write system call). =A0If we do, then the f=
irst
>> write into uninitialized block will cause a synchronous journal comm=
it
>> that will be Slow And Painful, and it might destroy most of the
>> performance benefits that might tempt an enterprise database client =
to
>> use fallocate() in the first place.
>>
>> I wonder how XFS deals with this case? =A0It's a problem that is goi=
ng
>> to hit any journalled filesystem that wants to support fallocate() a=
nd
>> direct I/O.
>>
>> One thing I can think of potentially doing is to check to see if the
>> extent tree block has already been journalled, and if it is not
>> currently involved the current transaction or the previous committin=
g
>> transaction, *and* if there is space in the extent tree to mark the
>> current unitialized block as initialized (i.e., if the extent needs =
to
>> be split, there is sufficient space so we don't have to allocate a n=
ew
>> leaf block for the extent tree), we could update the leaf block in
>> place and then synchronously write it out, and thus avoid needing to
>> do a synchronous journal commit.
>
> In my example above, when KEEP_SIZE is used, it appears that
> converting the uninit extent to initialized never failed. =A0I haven'=
t
> waded through ext4_ext_convert_to_initialized() to see how it might
> fail, and tried to get it to do so.
>
> It would be interesting to see if making this work -- having the
> blocks allocated and the buffer mapped -- for O_DIRECT writes in the
> absence of a journal, at least, would be feasible. =A0It would certai=
nly
> be useful, to us at least.
>
> Thanks,
> Curt
>
>>
>> In any case, adding this support is going to be non-trivial. =A0If
>> someone has time to work on it in the next 2-3 weeks or so, I can pu=
sh
>> it to Linus as a bug fix --- but I'm concerned the fixing this may b=
e
>> tricky enough (and the patch invasive enough) that it might be
>> challenging to get this fixed in time for 2.6.31.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
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
