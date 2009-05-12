From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Tue, 12 May 2009 09:28:53 -0400
Message-ID: <87f94c370905120628r2352e923h43dca1645e197b6c@mail.gmail.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu>
	 <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
	 <20090511142740.GC6277@mit.edu> <4A08365F.5040805@redhat.com>
	 <20090511145059.GD6277@mit.edu>
	 <20090511150040.GF8112@parisc-linux.org>
	 <87f94c370905111147t77250b92pc511ef9c6c0e7e42@mail.gmail.com>
	 <18952.46829.115084.46432@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	"J?rn Engel" <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:46641 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZELN2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 09:28:52 -0400
In-Reply-To: <18952.46829.115084.46432@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 7:38 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday May 11, greg.freemyer@gmail.com wrote:
>>
>> And since the mdraid layer is not currently planning to track what h=
as
>> been discarded over time, when a re-shape comes along, it will
>> effectively un-trim everything and rewrite 100% of the FS.
>
> You might not call them "plans" exactly, but I have had thoughts
> about tracking which part of an raid5 had 'live' data and which were
> trimmed. =A0I think that is the only way I could support TRIM, unless
> devices guarantee that all trimmed blocks read a zeros, and that seem=
s
> unlikely.

Neil,

Re: raid 5, etc. No FS info/discussion

The latest T13 proposed spec I saw explicitly allows reads from
trimmed sectors to return non-determinate data in some devices.  Their
is a per device flag you can read to see if a device does that or not.
 I think mdraid needs to simply assume all trimmed sectors return
non-determinate data.  Either that, or simply check that per device
flag and refuse to accept a drive that supports returning
non-determinate data.

Regardless, ignoring reshape, why do you need to track it?

=2E.. thinking

Oh yes, you will have to track it at least at the stripe level.

If p =3D d1 ^ d2 is not guaranteed to be true due to a stripe discard
and p, d1, d2 are all potentially non-determinate all is good at first
because who cares that d1 =3D p ^ d2 is not true for your discarded
stripe.  d1 is effectively just random data anyway.

But as soon as either d1 or d2 is written to, you will need to force
the entire stripe back into a determinate state or else you will have
unprotected data sitting on that stripe.  You can only do that if you
know the entire stripe was previously indeterminate, thus you have no
option but to track the state of the stripes if dmraid is going to
support discards with devices that advertise themselves as returning
indeterminate data.

So Neil, it looks like you need to move from thoughts about tracking
discards to planning to track discards.

=46YI: I don't know if it just for show, or if people really plan to do
it, but I have seen several people build up very high performance raid
arrays from SSDs already.  Seems that about 8 SSDs maxes out the
current group of sata controllers, pci-express, etc.

Since SSDs with trim support should be even faster, I suspect these
ultra-high performance setups will want to use them.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
