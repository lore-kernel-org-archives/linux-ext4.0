From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Fallocate and DirectIO
Date: Tue, 21 Jul 2009 18:27:30 -0700
Message-ID: <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZGVB1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 21:27:36 -0400
Received: from spaceape14.eur.corp.google.com (spaceape14.eur.corp.google.com [172.28.16.148])
	by smtp-out.google.com with ESMTP id n6M1RW14009653
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2009 02:27:33 +0100
Received: from pzk9 (pzk9.prod.google.com [10.243.19.137])
	by spaceape14.eur.corp.google.com with ESMTP id n6M1QWlW021520
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 18:27:30 -0700
Received: by pzk9 with SMTP id 9so2509160pzk.21
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 18:27:30 -0700 (PDT)
In-Reply-To: <20090612173301.GC6417@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I spent a bit of time looking at this today.

On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrote:
>> Hi,
>>
>> I noticed yesterday that a write to fallocate
>> space via directIO results in fallback to buffer_IO. ie the userspac=
e
>> pages get copied to the page cache and then call a sync.
>>
>> I guess this defeat the purpose of using directIO. May be we should
>> consider this a high priority bug.

My simple experiment -- without a journal -- shows that you're
observation is correct.  *Except* if FALLOC_FL_KEEP_SIZE is used in
the fallocate() call, in which case the page cache is *not* used.

Pseudo-code example:

  open(O_DIRECT)
  fallocate(mode, 512MB)
  while (! written 100MB)
     write(64K)
  close()

If mode =3D=3D FALLOC_FL_KEEP_SIZE, then no page cache is used.
Otherwise, we *do* go through the page cache.

It comes down to the fact that, since the i_size is not updated with
KEEP_SIZE, then ext4_get_block() is called with create =3D 1, since the
block that's needed is "beyond" the file end.

>
> I agree that many of users of fallocate() feature (i.e. databases) ar=
e
> going to consider this to be a major misfeature.

>
> There's going to be a major performance hit though --- O_DIRECT is
> supposed to be synchronous if all of the alignment requirements are
> met, which means that by the time the write(2) system call returns,
> the data is guaranteed to be on disk. =A0But if we need to manipulate
> the extent tree to indicate that the block is now in use (so the data
> is actually accessible), do we force a synchronous journal commit or
> not? =A0If we don't, then a crash right after an O_DIRECT right into =
an
> uninitialized region will cause the data to be "lost" (or at least,
> unavailable via the read/write system call). =A0If we do, then the fi=
rst
> write into uninitialized block will cause a synchronous journal commi=
t
> that will be Slow And Painful, and it might destroy most of the
> performance benefits that might tempt an enterprise database client t=
o
> use fallocate() in the first place.
>
> I wonder how XFS deals with this case? =A0It's a problem that is goin=
g
> to hit any journalled filesystem that wants to support fallocate() an=
d
> direct I/O.
>
> One thing I can think of potentially doing is to check to see if the
> extent tree block has already been journalled, and if it is not
> currently involved the current transaction or the previous committing
> transaction, *and* if there is space in the extent tree to mark the
> current unitialized block as initialized (i.e., if the extent needs t=
o
> be split, there is sufficient space so we don't have to allocate a ne=
w
> leaf block for the extent tree), we could update the leaf block in
> place and then synchronously write it out, and thus avoid needing to
> do a synchronous journal commit.

In my example above, when KEEP_SIZE is used, it appears that
converting the uninit extent to initialized never failed.  I haven't
waded through ext4_ext_convert_to_initialized() to see how it might
fail, and tried to get it to do so.

It would be interesting to see if making this work -- having the
blocks allocated and the buffer mapped -- for O_DIRECT writes in the
absence of a journal, at least, would be feasible.  It would certainly
be useful, to us at least.

Thanks,
Curt

>
> In any case, adding this support is going to be non-trivial. =A0If
> someone has time to work on it in the next 2-3 weeks or so, I can pus=
h
> it to Linus as a bug fix --- but I'm concerned the fixing this may be
> tricky enough (and the patch invasive enough) that it might be
> challenging to get this fixed in time for 2.6.31.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
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
