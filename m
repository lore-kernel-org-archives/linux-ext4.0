From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Fallocate and DirectIO
Date: Fri, 24 Jul 2009 11:18:38 -0700
Message-ID: <6601abe90907241118u57370bf0j53a8c22147a892f0@mail.gmail.com>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu>
	 <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
	 <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com>
	 <1248396972.1354.47.camel@mingming-laptop>
	 <6601abe90907240930t5232329byb1c2c6930abcb473@mail.gmail.com>
	 <20090724180225.GA29851@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:35746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbZGXSSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 14:18:43 -0400
Received: from spaceape14.eur.corp.google.com (spaceape14.eur.corp.google.com [172.28.16.148])
	by smtp-out.google.com with ESMTP id n6OIIf5p003643
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 19:18:41 +0100
Received: from pzk34 (pzk34.prod.google.com [10.243.19.162])
	by spaceape14.eur.corp.google.com with ESMTP id n6OIIcib019987
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 11:18:39 -0700
Received: by pzk34 with SMTP id 34so1197483pzk.4
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 11:18:38 -0700 (PDT)
In-Reply-To: <20090724180225.GA29851@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2009 at 11:02 AM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Fri, Jul 24, 2009 at 09:30:08AM -0700, Curt Wohlgemuth wrote:
>> On Thu, Jul 23, 2009 at 5:56 PM, Mingming<cmm@us.ibm.com> wrote:
>> > On Thu, 2009-07-23 at 08:56 -0700, Curt Wohlgemuth wrote:
>> >> On Tue, Jul 21, 2009 at 6:27 PM, Curt Wohlgemuth<curtw@google.com=
> wrote:
>> >> > I spent a bit of time looking at this today.
>> >> >
>> >> > On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> w=
rote:
>> >> >> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wro=
te:
>> >> >>> Hi,
>> >> >>>
>> >> >>> I noticed yesterday that a write to fallocate
>> >> >>> space via directIO results in fallback to buffer_IO. ie the u=
serspace
>> >> >>> pages get copied to the page cache and then call a sync.
>> >> >>>
>> >> >>> I guess this defeat the purpose of using directIO. May be we =
should
>> >> >>> consider this a high priority bug.
>> >> >
>> >> > My simple experiment -- without a journal -- shows that you're
>> >> > observation is correct. =A0*Except* if FALLOC_FL_KEEP_SIZE is u=
sed in
>> >> > the fallocate() call, in which case the page cache is *not* use=
d.
>> >> >
>> >> > Pseudo-code example:
>> >> >
>> >> > =A0open(O_DIRECT)
>> >> > =A0fallocate(mode, 512MB)
>> >> > =A0while (! written 100MB)
>> >> > =A0 =A0 write(64K)
>> >> > =A0close()
>> >> >
>> >> > If mode =3D=3D FALLOC_FL_KEEP_SIZE, then no page cache is used.
>> >> > Otherwise, we *do* go through the page cache.
>> >> >
>> >> > It comes down to the fact that, since the i_size is not updated=
 with
>> >> > KEEP_SIZE, then ext4_get_block() is called with create =3D 1, s=
ince the
>> >> > block that's needed is "beyond" the file end.
>> >>
>> > I think so.
>> > In the case of KEEP_SIZE, get_block() is called with create=3D1 be=
fore dio
>> > submit the real data IO, thus dio get a chance to convert the
>> > uninitalized extents to initialized before returns back to the cal=
ler.
>>
>> Ah, I see this now in ext4_direct_IO(). =A0Thanks.
>>
>> > But in the case of non KEEP_SIZE, i.e. updating i_size after fallo=
cate()
>> > case, we now have to fall back to buffered IO to ensure the extent=
s
>> > conversion is happened in an ordering. Because if we convert the e=
xtents
>> > before submit the IO, and this conversion reached to disk, if syst=
em
>> > crash before the real data IO finished, then it could expose the s=
tale
>> > data out, as the extent has already marked "initialized".
>>
>> Yes, that makes sense -- since i_size already covers the formerly
>> uninitialized, now initialized, extents.
>>
>> >> Ted, given your concerns over the performance impact of updating =
the
>> >> extents during direct I/O writes, it would seem that the fact tha=
t
>> >> when KEEP_SIZE is specified we do the DMA (and don't go through t=
he
>> >> page cache) would be a problem/bug. =A0At least, it seems that th=
e
>> >> performance issue is the same regardless of whether KEEP_SIZE is =
used
>> >> on the fallocate or not: in both we're dealing with an uninitiali=
zed
>> >> extent. =A0Do you agree?
>> >
>> > Here is what I thought...
>> >
>> > I think updating the extents itself is not a big performance conce=
rn, In
>> > the non KEEP_SIZE case, if we don't want to fall back to buffered =
IO,
>> > ext4 DIO has to wait for the journal to commit the transaction whi=
ch
>> > converts extents to complete, before DIO could return back apps, t=
his
>> > could be a big latency. That seems what xfs does.
>>
>> Wouldn't this still be an exposure to stale data? =A0The only way fo=
r
>> this to work, if i_size already covers the uninit extents, is to mak=
e
>> sure the data goes to disk before the extents get converted and
>> committed. =A0Since the extents are converted in the ext4_get_block(=
)
>> path, before DIO actually performs the data write, this seems to be
>> too late.
>>
>> > For KEEP_SIZE case, The conversion actually could happen before th=
e
>> > related IO reach to disk, I guess the oraph inode list protects st=
ale
>> > data get exposed in this case.
>>
>> I'm sorry, I don't follow you here.
>>
>> >> I'm exploring (a) what this performance penalty is for the journa=
l
>> >> commit; and (b) can we at least avoid the page cache if your
>> >> conditions above (no journal commit; no new extent blocks) are me=
t.
>> >
>> > In fact, in the case of no journal, as long as the extents convers=
ion
>> > happens after the data IO reach to disk, it should be safe, am I r=
ight?
>> > If system crash before the extent conversion finish, we only lost
>> > recently updated IO, but won't expose the stale data out, as the e=
xtents
>> > is still marked as uninitialized.
>>
>> But again, the extent conversion (and mark_inode_dirty()) happens at
>> get_block time, before the data goes to disk.
>>
>> For KEEP_SIZE, this isn't an exposure because i_size prevents the da=
ta
>> from being read. =A0But without KEEP_SIZE, this would seem to be a
>> problem, right?
>>
>> (From a practical perspective, there's also a problem getting real D=
IO
>> to work without KEEP_SIZE in the fallocate(): =A0the decision to sen=
d
>> "create=3D0" to ext4_get_block() happens in VFS code, and there's no=
 way
>> to tell in the get_block path that "this is a 'no create' for a writ=
e,
>> vs. a read.)
>
> What we need is to track I/O's untill they hit the disk. This will
> help us to do data=3Dguarded and also help in the above case. So
> for directIO we should use blockdev_direct_IO_own_locking and the get=
_block
> used should split the uninit extent the needed way but still mark it
> uninit. That would make sure a read will see the uninit extent and re=
turn
> zero as expected. Now on IO completion we should mark split uninit ex=
tent
> as init.

I can see how using DIO_OWN_LOCKING would allow a write to send
"create=3D1" to ext4_get_block().  That would be cool.

Are you then saying that we would need to postpone the
ext4_ext_convert_to_initialized() call in ext4_ext_get_blocks(), and
then have ext4_direct_IO() do this conversion on return from
blockdev_direct_IO_own_locking()?  That would seem to be required...

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
