From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Update Documentation/md.txt to mention journaling
	won't help dirty+degraded case.
Date: Thu, 3 Sep 2009 14:31:11 +0200
Message-ID: <20090903123111.GA4227@ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz> <200909021749.47695.rob@landley.net> <4A9FB10B.60209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A9FB10B.60209@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 2009-09-03 08:05:31, Ric Wheeler wrote:
> On 09/02/2009 06:49 PM, Rob Landley wrote:
>> From: Rob Landley<rob@landley.net>
>>
>> Add more warnings to the "Boot time assembly of degraded/dirty arrays" section,
>> explaining that using a journaling filesystem can't overcome this problem.
>>
>> Signed-off-by: Rob Landley<rob@landley.net>
>> ---
>>
>>   Documentation/md.txt |   17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/Documentation/md.txt b/Documentation/md.txt
>> index 4edd39e..52b8450 100644
>> --- a/Documentation/md.txt
>> +++ b/Documentation/md.txt
>> @@ -75,6 +75,23 @@ So, to boot with a root filesystem of a dirty degraded raid[56], use
>>
>>      md-mod.start_dirty_degraded=1
>>
>> +Note that Journaling filesystems do not effectively protect data in this
>> +case, because the update granularity of the RAID is larger than the journal
>> +was designed to expect.  Reconstructing data via partity information involes
>> +matching together corresponding stripes, and updating only some of these
>> +stripes renders the corresponding data in all the unmatched stripes
>> +meaningless.  Thus seemingly unrelated data in other parts of the filesystem
>> +(stored in the unmatched stripes) can become unreadable after a partial
>> +update, but the journal is only aware of the parts it modified, not the
>> +"collateral damage" elsewhere in the filesystem which was affected by those
>> +changes.
>> +
>> +Thus successful journal replay proves nothing in this context, and even a
>> +full fsck only shows whether or not the filesystem's metadata was affected.
>> +(A proper solution to this problem would involve adding journaling to the RAID
>> +itself, at least during degraded writes.  In the meantime, try not to allow
>> +a system to shut down uncleanly with its RAID both dirty and degraded, it
>> +can handle one but not both.)
>>
>>   Superblock formats
>>   ------------------
>>
>>
>
> NACK.
>
> Now you have moved the inaccurate documentation about journalling file 
> systems into the MD documentation.

What is inaccurate about it?

> Repeat after me:

> (1) partial writes to a RAID stripe (with or without file systems, with 
> or without journals) create an invalid stripe

That's what he's documenting.

> (2) partial writes can be prevented in most cases by running with write 
> cache disabled or working barriers

Given how long experience with storage you claim, you should know that
MD RAID5 does not support barriers by now...


> Rob, you should really try to take a few disks, build a working MD RAID5 
> group and test your ideas. Try it with and without the write cache 
> enabled.

....and understand by now that statistics are irrelevant for design
problems.

Ouch and trying to silence people by telling them to fix the problem
instead of documenting it is not nice either.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
