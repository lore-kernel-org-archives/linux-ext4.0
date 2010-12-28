From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 17:00:55 -0500
Message-ID: <AANLkTimxbjEntSBYxzxnHnOOCUkdNyGWJ40HGG=0d0E5@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org> <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
 <20101225031529.GA2595@thunk.org> <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
 <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
 <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
 <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
 <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
 <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
 <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
 <20101226221016.GF2595@thunk.org> <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
 <4D18B106.4010308@ontolinux.com> <AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
 <4D18E94C.3080908@ontolinux.com> <AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
 <20101229075928.6bdafb08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0L1WBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 17:01:16 -0500
In-Reply-To: <20101229075928.6bdafb08@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 3:59 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 28 Dec 2010 18:22:42 +0100 Olaf van der Spek <olafvdspek@gmai=
l.com>
> wrote:
>
>> On Mon, Dec 27, 2010 at 8:30 PM, Christian Stroetmann
>> <stroetmann@ontolinux.com> wrote:
>> > Btw.: There is even no analogy: "The concepts are the same".
>>
>> So? Doesn't mean you implement full ACID DB-like transactions.
>>
>> >>>> Still waiting on any hint for why that performance loss would h=
appen.
>> >>>
>> >>> > From my point of view, the loss of performance depends on what=
 is
>> >>> benchmarked in which way.
>> >>
>> >> Maybe, but still no indication of why.
>> >
>> > If you have a solution, then you really should show other persons =
the
>> > working source code.
>>
>> I don't have source code.
>> Are you not capable of reasoning about something without having
>> concrete source code?
>>
>> > For me speaking: I like such technologies and I'm also interested =
in your
>> > attempts.
>>
>> Writing code is a lot of work and one should have the design clear
>> before writing code, IMO.
>
> Yes and no.
>
> Having some design is obviously important before starting to code.
> However it is a common experience that once you start writing code, y=
ou start
> to see all the holes in your design - all the corner cases that you d=
idn't
> think about. =A0So sometimes writing some proof-of-concept code is a =
very
> valuable step in the design process.
> Then of course you need to do some testing to see if in the code actu=
ally
> performs as hoped or expected. =A0That testing may cause the design t=
o be
> revised.
> So asking for code early is not necessarily a bad thing.
>
> I think the real disconnect here is that you haven't really establish=
ed or
> justified a need.
>
> You seem to be asking for the ability to atomically change the data i=
n a file
> without changing the metadata. =A0I cannot see why you would want thi=
s. =A0Maybe
> you could give an explicit use-case??

=3D=3D> joining the thread

I assumed the use case was one of simple document editor.

If I am working on a office doc with oowriter as an example, I don't
want a system crash or out of diskspace to kill my original doc.  7 or
8 years ago XFS used to zero out the file in situations like that.
Hopefully that's fixed.

What I don't understand is what the security impacts are of the file
owner changing.  ie. Assume user 1 creates a word doc, then user 2
makes an edit.  If the owner is changed to the second user, is that a
problem?

Same for the group?

Personally I'd rather see it stay with the original owner / group.

I assume the solution today that oowriter etc. use is:

=3D=3D=3D
create temp file
write out new data
delete old file
rename temp file to primary name
=3D=3D=3D

If so there is still a little window of vulnerability where the whole
file can be lost.  (Or at least only the temp file is present).

Text editors, xml editors, etc. seem like they all have the same vulner=
ability.

If my assumptions are right, then a way to guarantee either the old or
new file contents are available after a crash would be useful.

=3D=3D EXT4_IOC_MOVE_EXT

There was mention of this ioctl earlier in the thread.

I don't think it guarantees all or nothing data replacement as
requested here.  It is designed with defragment as the primary use
case.

As such it steps through data blocks and replaces them, but if only
half the blocks get replaced with new ones due to a crash, it is not a
big deal.

Greg
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
