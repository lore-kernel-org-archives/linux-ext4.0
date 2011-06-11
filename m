From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Sat, 11 Jun 2011 12:58:26 +0300
Message-ID: <BANLkTi=THJi8Z2RTdfGgox4NH8hEGiN37A@mail.gmail.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
	<BANLkTi=0N7QXRvFgjHUJXBi0x=668ahXXA@mail.gmail.com>
	<20110611073517.GB2517@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Joe Thornber <thornber@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110611073517.GB2517@ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 11, 2011 at 10:35 AM, Joe Thornber <thornber@redhat.com> wr=
ote:
> On Sat, Jun 11, 2011 at 08:41:38AM +0300, Amir G. wrote:
>> On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> =
wrote:
>> > On Fri, Jun 10, 2011 at 11:01:41AM +0200, Lukas Czerner wrote:
>> >> On Fri, 10 Jun 2011, Amir G. wrote:
>> >>
>> >> > CC'ing lvm-devel and fsdevel
>> >> >
>> >> >
>> >> > On Wed, Jun 8, 2011 at 9:26 PM, Amir G. <amir73il@users.sourcef=
orge.net> wrote:
>> >> > For the sake of letting everyone understand the differences and=
 trade
>> >> > offs between
>> >> > LVM and ext4 snapshots, so ext4 snapshots can get a fair trial,=
 I need
>> >> > to ask you
>> >> > some questions about the implementation, which I could not figu=
re out by myself
>> >> > from reading the documents.
>> >
>> > First up let me say that I'm not intending to support writeable
>> > _external_ origins with multisnap. =A0This will come as a suprise =
to
>> > many people, but I don't think we can resolve the dual requirement=
s to
>> > efficiently update many, many snapshots when a write occurs _and_ =
make
>> > those snapshots quick to delete (when you're encouraging people to
>> > take lots of snapshots performance of delete becomes a real issue)=
=2E
>> >
>>
>> If I understand this article correctly:
>> http://people.redhat.com/mpatocka/papers/shared-snapshots.pdf
>> It says that _external_ origin write updates can be efficient to rea=
donly
>> (or not written) snapshots.
>>
>> Could you not support readonly snapshots of an _external_ origin?
>
> Yes, that is the intention, and very little work to add. =A0We just d=
o
> something different if the metadata lookup returns -ENODATA. =A0Above=
 I
> said I didn't intend to support _writeable_ external snaps. =A0Readab=
le
> ones are a must, for instance for supporting virtual machine base
> images.
>
>> You could even support writable snapshots, that will degrade write
>> performance to origin temporarily.
>> It can be useful, if one wants to "try-out" mounting a temporary
>> writable snapshot, when the origin is not even mounted.
>> After the "try-out", the temporary snapshot can be deleted
>> and origin write performance would go back to normal.
>
> Not sure what you're getting at here. =A0All snapshots are writeable.
>

I meant _readonly_ snapshots of a _writable_ _external_ origin,
which is what ext4 snapshots provides.
All snapshots are chained on a list that points to the origin and
only the latest (active) snapshot metadata get updated on origin writes=
=2E
When older snapshots lookup return -ENODATA, you go up the list
to the newer snapshot and up to the origin.

Those _incremental_ snapshots cannot be _writable_, because older
snapshots may implicitly share blocks with newer snapshots, but it shou=
ld
be possible to make _writable_ clones of these snapshots.
Not sure what the implications are for deleting snapshots, because I am
not familiar with all the implementation details of multisnap.


> Of course you can take a snapshot of an external origin and then use
> this as your temporary origin for experiments. =A0If the origin is
> itself a dm device then LVM can shuffle tables around to make this
> transparent.
>
> The user may want to commit to their experiment at a later time by
> merging back to the external origin. =A0This involves copying, but no
> more than a copy-on-write scheme. =A0Arguably it's better to do the c=
opy
> only once we know they want to commit to it.
>
> - Joe
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
