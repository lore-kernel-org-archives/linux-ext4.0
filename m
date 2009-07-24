From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Fallocate and DirectIO
Date: Fri, 24 Jul 2009 09:30:08 -0700
Message-ID: <6601abe90907240930t5232329byb1c2c6930abcb473@mail.gmail.com>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu>
	 <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
	 <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com>
	 <1248396972.1354.47.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:22777 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGXQaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 12:30:16 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id n6OGUC2h014593
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 17:30:12 +0100
Received: from pzk5 (pzk5.prod.google.com [10.243.19.133])
	by spaceape9.eur.corp.google.com with ESMTP id n6OGU8Im009319
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 09:30:09 -0700
Received: by pzk5 with SMTP id 5so1352999pzk.26
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 09:30:08 -0700 (PDT)
In-Reply-To: <1248396972.1354.47.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 23, 2009 at 5:56 PM, Mingming<cmm@us.ibm.com> wrote:
> On Thu, 2009-07-23 at 08:56 -0700, Curt Wohlgemuth wrote:
>> On Tue, Jul 21, 2009 at 6:27 PM, Curt Wohlgemuth<curtw@google.com> w=
rote:
>> > I spent a bit of time looking at this today.
>> >
>> > On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> wrot=
e:
>> >> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrote:
>> >>> Hi,
>> >>>
>> >>> I noticed yesterday that a write to fallocate
>> >>> space via directIO results in fallback to buffer_IO. ie the user=
space
>> >>> pages get copied to the page cache and then call a sync.
>> >>>
>> >>> I guess this defeat the purpose of using directIO. May be we sho=
uld
>> >>> consider this a high priority bug.
>> >
>> > My simple experiment -- without a journal -- shows that you're
>> > observation is correct. =A0*Except* if FALLOC_FL_KEEP_SIZE is used=
 in
>> > the fallocate() call, in which case the page cache is *not* used.
>> >
>> > Pseudo-code example:
>> >
>> > =A0open(O_DIRECT)
>> > =A0fallocate(mode, 512MB)
>> > =A0while (! written 100MB)
>> > =A0 =A0 write(64K)
>> > =A0close()
>> >
>> > If mode =3D=3D FALLOC_FL_KEEP_SIZE, then no page cache is used.
>> > Otherwise, we *do* go through the page cache.
>> >
>> > It comes down to the fact that, since the i_size is not updated wi=
th
>> > KEEP_SIZE, then ext4_get_block() is called with create =3D 1, sinc=
e the
>> > block that's needed is "beyond" the file end.
>>
> I think so.
> In the case of KEEP_SIZE, get_block() is called with create=3D1 befor=
e dio
> submit the real data IO, thus dio get a chance to convert the
> uninitalized extents to initialized before returns back to the caller=
=2E

Ah, I see this now in ext4_direct_IO().  Thanks.

> But in the case of non KEEP_SIZE, i.e. updating i_size after fallocat=
e()
> case, we now have to fall back to buffered IO to ensure the extents
> conversion is happened in an ordering. Because if we convert the exte=
nts
> before submit the IO, and this conversion reached to disk, if system
> crash before the real data IO finished, then it could expose the stal=
e
> data out, as the extent has already marked "initialized".

Yes, that makes sense -- since i_size already covers the formerly
uninitialized, now initialized, extents.

>> Ted, given your concerns over the performance impact of updating the
>> extents during direct I/O writes, it would seem that the fact that
>> when KEEP_SIZE is specified we do the DMA (and don't go through the
>> page cache) would be a problem/bug. =A0At least, it seems that the
>> performance issue is the same regardless of whether KEEP_SIZE is use=
d
>> on the fallocate or not: in both we're dealing with an uninitialized
>> extent. =A0Do you agree?
>
> Here is what I thought...
>
> I think updating the extents itself is not a big performance concern,=
 In
> the non KEEP_SIZE case, if we don't want to fall back to buffered IO,
> ext4 DIO has to wait for the journal to commit the transaction which
> converts extents to complete, before DIO could return back apps, this
> could be a big latency. That seems what xfs does.

Wouldn't this still be an exposure to stale data?  The only way for
this to work, if i_size already covers the uninit extents, is to make
sure the data goes to disk before the extents get converted and
committed.  Since the extents are converted in the ext4_get_block()
path, before DIO actually performs the data write, this seems to be
too late.

> For KEEP_SIZE case, The conversion actually could happen before the
> related IO reach to disk, I guess the oraph inode list protects stale
> data get exposed in this case.

I'm sorry, I don't follow you here.

>> I'm exploring (a) what this performance penalty is for the journal
>> commit; and (b) can we at least avoid the page cache if your
>> conditions above (no journal commit; no new extent blocks) are met.
>
> In fact, in the case of no journal, as long as the extents conversion
> happens after the data IO reach to disk, it should be safe, am I righ=
t?
> If system crash before the extent conversion finish, we only lost
> recently updated IO, but won't expose the stale data out, as the exte=
nts
> is still marked as uninitialized.

But again, the extent conversion (and mark_inode_dirty()) happens at
get_block time, before the data goes to disk.

=46or KEEP_SIZE, this isn't an exposure because i_size prevents the dat=
a
from being read.  But without KEEP_SIZE, this would seem to be a
problem, right?

(From a practical perspective, there's also a problem getting real DIO
to work without KEEP_SIZE in the fallocate():  the decision to send
"create=3D0" to ext4_get_block() happens in VFS code, and there's no wa=
y
to tell in the get_block path that "this is a 'no create' for a write,
vs. a read.)

Thanks,
Curt

>
> Regards,
> Mingming
>> >
>> >>
>> >> I agree that many of users of fallocate() feature (i.e. databases=
) are
>> >> going to consider this to be a major misfeature.
>> >
>> >>
>> >> There's going to be a major performance hit though --- O_DIRECT i=
s
>> >> supposed to be synchronous if all of the alignment requirements a=
re
>> >> met, which means that by the time the write(2) system call return=
s,
>> >> the data is guaranteed to be on disk. =A0But if we need to manipu=
late
>> >> the extent tree to indicate that the block is now in use (so the =
data
>> >> is actually accessible), do we force a synchronous journal commit=
 or
>> >> not? =A0If we don't, then a crash right after an O_DIRECT right i=
nto an
>> >> uninitialized region will cause the data to be "lost" (or at leas=
t,
>> >> unavailable via the read/write system call). =A0If we do, then th=
e first
>> >> write into uninitialized block will cause a synchronous journal c=
ommit
>> >> that will be Slow And Painful, and it might destroy most of the
>> >> performance benefits that might tempt an enterprise database clie=
nt to
>> >> use fallocate() in the first place.
>> >>
>> >> I wonder how XFS deals with this case? =A0It's a problem that is =
going
>> >> to hit any journalled filesystem that wants to support fallocate(=
) and
>> >> direct I/O.
>> >>
>> >> One thing I can think of potentially doing is to check to see if =
the
>> >> extent tree block has already been journalled, and if it is not
>> >> currently involved the current transaction or the previous commit=
ting
>> >> transaction, *and* if there is space in the extent tree to mark t=
he
>> >> current unitialized block as initialized (i.e., if the extent nee=
ds to
>> >> be split, there is sufficient space so we don't have to allocate =
a new
>> >> leaf block for the extent tree), we could update the leaf block i=
n
>> >> place and then synchronously write it out, and thus avoid needing=
 to
>> >> do a synchronous journal commit.
>> >
>> > In my example above, when KEEP_SIZE is used, it appears that
>> > converting the uninit extent to initialized never failed. =A0I hav=
en't
>> > waded through ext4_ext_convert_to_initialized() to see how it migh=
t
>> > fail, and tried to get it to do so.
>> >
>> > It would be interesting to see if making this work -- having the
>> > blocks allocated and the buffer mapped -- for O_DIRECT writes in t=
he
>> > absence of a journal, at least, would be feasible. =A0It would cer=
tainly
>> > be useful, to us at least.
>> >
>> > Thanks,
>> > Curt
>> >
>> >>
>> >> In any case, adding this support is going to be non-trivial. =A0I=
f
>> >> someone has time to work on it in the next 2-3 weeks or so, I can=
 push
>> >> it to Linus as a bug fix --- but I'm concerned the fixing this ma=
y be
>> >> tricky enough (and the patch invasive enough) that it might be
>> >> challenging to get this fixed in time for 2.6.31.
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
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
