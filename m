From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 13:12:08 +0200
Message-ID: <20090826111208.GA26595@elf.ucw.cz>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A9510D2.1090704@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 2009-08-26 06:39:14, Ric Wheeler wrote:
> On 08/25/2009 10:58 PM, Theodore Tso wrote:
>> On Tue, Aug 25, 2009 at 09:15:00PM -0400, Ric Wheeler wrote:
>>    
>>> I agree with the whole write up outside of the above - degraded RAID
>>> does meet this requirement unless you have a second (or third, counting
>>> the split write) failure during the rebuild.
>>>      
>> The argument is that if the degraded RAID array is running in this
>> state for a long time, and the power fails while the software RAID is
>> in the middle of writing out a stripe, such that the stripe isn't
>> completely written out, we could lose all of the data in that stripe.
>>
>> In other words, a power failure in the middle of writing out a stripe
>> in a degraded RAID array counts as a second failure.
>>    To me, this isn't a particularly interesting or newsworthy point,
>> since a competent system administrator who cares about his data and/or
>> his hardware will (a) have a UPS, and (b) be running with a hot spare
>> and/or will imediately replace a failed drive in a RAID array.
>
> I agree that this is not an interesting (or likely) scenario, certainly  
> when compared to the much more frequent failures that RAID will protect  
> against which is why I object to the document as Pavel suggested. It  
> will steer people away from using RAID and directly increase their  
> chances of losing their data if they use just a single disk.

So instead of fixing or at least documenting known software deficiency
in Linux MD stack, you'll try to surpress that information so that
people use more of raid5 setups?

Perhaps the better documentation will push them to RAID1, or maybe
make them buy an UPS?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
