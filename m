From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 14:30:54 -0400
Message-ID: <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	 <alpine.LFD.2.00.1004230944070.2814@localhost>
	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
	 <4BD2F69D.7070508@redhat.com>
	 <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
	 <4BD30393.4050800@redhat.com>
	 <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>
	 <4BD324B5.4030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:46968 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0DXSa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 14:30:56 -0400
Received: by qyk9 with SMTP id 9so15005497qyk.1
        for <linux-ext4@vger.kernel.org>; Sat, 24 Apr 2010 11:30:55 -0700 (PDT)
In-Reply-To: <4BD324B5.4030808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 24, 2010 at 1:04 PM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
<snip>
>
> Let's summarize.
>
> 1. Everyone agrees that doing larger discard instead of little discar=
ds is a
> good thing.
>
> 2. Some devices care about this more than others (various types of SS=
D's and
> arrays have different designs and performance with discards). Some de=
vices
> do small discards well, others don't.
>
> 3. How you get to those bigger discards in our implementation - using=
 a
> series of single range requests, using vectored requests, tracking ex=
tents
> that can be combined in an rbtree or not - is something that we are w=
orking
> on. Using rbtrees versus a bitmap efficiency is about DRAM consumptio=
n, not
> performance of the resulting discard on the target.
>
> 4. Devices (some devices) can export their preferences in a standard =
way
> (look in /sys/block/....).
>
> If you want to influence the code, please do try the various options =
on
> devices you have at hand and report results. =A0That is what we are d=
oing (we
> includes Lukas, Eric, Jeff and others on this thread) will real devic=
es from
> vendors that have given us access. We are talking to them directly an=
d
> trying out different work loads but certainly welcome real world resu=
lts and
> suggestions.
>
> Thanks!
>
> Ric

Ric,

Is it also agreed by all that the current ext4 kernel implementation
of calling discard is a poor solution for most hardware / block layers
stacks / workloads and therefore is not worth retaining nor performing
further benchmarks?

I've not seen anyone arguing to keep the current kernel implementation
and I for one accept the previously posted benchmarks that show it is
not adding any value relative to the traditional non-discard case.

Therefore benchmarks between the current hdparm/wiper.sh userspace
implementation and a proposed new kernel implementation would be the
most beneficial?

I have yet to see any of those benchmarks posted.

Greg



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
   http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets=
-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
