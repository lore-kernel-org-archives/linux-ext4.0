From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 14:47:30 -0400
Message-ID: <87f94c370905111147t77250b92pc511ef9c6c0e7e42@mail.gmail.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org>
	 <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu>
	 <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
	 <20090511142740.GC6277@mit.edu> <4A08365F.5040805@redhat.com>
	 <20090511145059.GD6277@mit.edu>
	 <20090511150040.GF8112@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	"J?rn Engel" <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090511150040.GF8112@parisc-linux.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 11:00 AM, Matthew Wilcox <matthew@wil.cx> wrote=
:
> On Mon, May 11, 2009 at 10:50:59AM -0400, Theodore Tso wrote:
>> On Mon, May 11, 2009 at 10:29:51AM -0400, Ric Wheeler wrote:
>> > The key is not at the FS layer - this is an issue for people who R=
AID
>> > these beasts together and want to actually check that the bits are=
 what
>> > they should be (say doing a checksum validity check for a stripe).
>>
>> Good point, yes I can see why they need that. =A0In that case, the
>> storage device can't just silently truncate a TRIM request; it would
>> have to expose to the OS its alignment requirements. =A0The risk tho=
ugh
>> is that more they try push this compleixity into the OS, the higher
>> the risk that the OS will simply decide not to take advantage of the
>> functionality. =A0Of course, there is the question why anyone would =
want
>> to build a software-raid device on top of a thin-provisioned hardwar=
e
>> storage unit. =A0:-)
>
> It's not a problem for people who use Thin Provisioning, it's a probl=
em
> for people who want to run RAID-5 on top of SSDs. =A0If you have a se=
ctor
> whose reads are indeterminate, your parity for that stripe will alway=
s
> be wrong.

Thus my understanding that entire stripe will either be discarded or
not by the mdraid layer.

And if a discard comes along from above that is smaller than a stripe,
then it will tossed by the mdraid layer.

And if it is not aligned to the stripe geometry, then the start/end of
the discard area will be adjusted to be stripe aligned.

And since the mdraid layer is not currently planning to track what has
been discarded over time, when a re-shape comes along, it will
effectively un-trim everything and rewrite 100% of the FS.

The same thing will happen if a drive is cloned via dd as happens
pretty routinely.

Overall, I think Linux will need a mechanism to scan a filesystem and
re-issue all the trim commands in order to get the hardware back in
sync a major maintenance activity.  That mechanism could either be
admin invoked.or a always on maintenance task.

Personally, I think the best option is a background task (kernel I
assume) to scan the filesystem and issue discards for all the data on
a slow but steady basis.  If it takes a week to make its way around
the disk/volume, then it takes a week.  Who really cares.

Once you assume you have that background task in place, I'm not sure
how important it is to even have the filesystem manage this in
realtime with the file deletes.

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
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
