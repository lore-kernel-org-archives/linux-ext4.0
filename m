From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 04:28:00 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com>
 <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090826111208.GA26595@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 26 Aug 2009, Pavel Machek wrote:

> On Wed 2009-08-26 06:39:14, Ric Wheeler wrote:
>> On 08/25/2009 10:58 PM, Theodore Tso wrote:
>>> On Tue, Aug 25, 2009 at 09:15:00PM -0400, Ric Wheeler wrote:
>>>
>>>> I agree with the whole write up outside of the above - degraded RAID
>>>> does meet this requirement unless you have a second (or third, counting
>>>> the split write) failure during the rebuild.
>>>>
>>> The argument is that if the degraded RAID array is running in this
>>> state for a long time, and the power fails while the software RAID is
>>> in the middle of writing out a stripe, such that the stripe isn't
>>> completely written out, we could lose all of the data in that stripe.
>>>
>>> In other words, a power failure in the middle of writing out a stripe
>>> in a degraded RAID array counts as a second failure.
>>>    To me, this isn't a particularly interesting or newsworthy point,
>>> since a competent system administrator who cares about his data and/or
>>> his hardware will (a) have a UPS, and (b) be running with a hot spare
>>> and/or will imediately replace a failed drive in a RAID array.
>>
>> I agree that this is not an interesting (or likely) scenario, certainly
>> when compared to the much more frequent failures that RAID will protect
>> against which is why I object to the document as Pavel suggested. It
>> will steer people away from using RAID and directly increase their
>> chances of losing their data if they use just a single disk.
>
> So instead of fixing or at least documenting known software deficiency
> in Linux MD stack, you'll try to surpress that information so that
> people use more of raid5 setups?
>
> Perhaps the better documentation will push them to RAID1, or maybe
> make them buy an UPS?

people aren't objecting to better documentation, they are objecting to 
misleading documentation.

for flash drives the danger is very straightforward (although even then 
you have to note that it depends heavily on the firmware of the device, 
some will loose lots of data, some won't loose any)

a good thing to do here would be for someone to devise a test to show this 
problem, and then gather the results of lots of people performing this 
test to see what the commonalities are.

you are generalizing that since you have lost data on flash drives, all 
flash drives are dangerous.

what if it turns out that only one manufacturer is doing things wrong? you 
will have discouraged people from using flash drives for no reason. 
(potentially causing them to loose data becouse they ae scared away from 
using flash drives and don't implement anything better)

to be safe, all that a flash drive needs to do is to not change the FTL 
pointers until the data has fully been recorded in it's new location. this 
is probably a trivial firmware change.


for raid arrays, we are still learning the nuances of what actually can 
happen. the comment that Rik made a few hours ago when he pointed out that 
with raid 5 you won't trash the entire stripe (which is what I thought 
happened from prior comments), but instead run the risk of loosing two 
relativly definable chunks of data

1. the block you are writing (which you can loose anyway)

2. the block that would live on the disk that is missing.

that drasticly lessens the impact of the problem

I would like to see someone explain what would happen on raid 6, and I 
think that the possibilities that Neil talked about where he said that it 
was possible to try the various combinations and see which ones agree with 
each other would be a good thing to implement if he can do so.

but the super simplified statement you keep trying to make is 
significantly overstating and oversimplifying the problem.

David Lang
