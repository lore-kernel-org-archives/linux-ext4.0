From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 09:11:58 -0400
Message-ID: <4A95349E.7010101__45222.1082676717$1251292283$gmane$org@redhat.com>
References: <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A9481BE.1030308@redhat.com> <20090826003803.GP4300@elf.ucw.cz> <4A9485A6.1010803@redhat.com> <20090826112121.GD26595@elf.ucw.cz> <4A952370.50603@redhat.com> <20090826124058.GK32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	david@lang.hm, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbZHZNLC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:11:02 -0400
In-Reply-To: <20090826124058.GK32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/26/2009 08:40 AM, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 07:58:40AM -0400, Ric Wheeler wrote:
>>> Drive in raid 5 failed; hot spare was available (no idea about
>>> UPS). System apparently locked up trying to talk to the failed drive,
>>> or maybe admin just was not patient enough, so he just powercycled the
>>> array. He lost the array.
>>>
>>> So while most people will not agressively powercycle the RAID array,
>>> drive failure still provokes little tested error paths, and getting
>>> unclean shutdown is quite easy in such case.
>>
>> Then what we need to document is do not power cycle an array during a
>> rebuild, right?
>
> Well, the softwar raid layer could be improved so that it implements
> scrubbing by default (i.e., have the md package install a cron job to
> implement a periodict scrub pass automatically).  The MD code could
> also regularly check to make sure the hot spare is OK; the other
> possibility is that hot spare, which hadn't been used in a long time,
> had silently failed.

Actually, MD does this scan already (not automatically, but you can set up a 
simple cron job to kick off a periodic "check"). It is a delicate balance to get 
the frequency of the scrubbing correct.

On one hand, you want to make sure that you detect errors in a timely fashion, 
certainly detection of single sector errors before you might develop a second 
sector level error on another drive.

On the other hand, running scans/scrubs continually impacts the performance of 
your real workload and can potentially impact your components' life span by 
subjecting them to a heavy workload.

Rule of thumb seems from my experience is that most people settle in with a scan 
once a week or two (done at a throttled rate).

>
>> In the end, there are cascading failures that will defeat any data
>> protection scheme, but that does not mean that the value of that scheme
>> is zero. We need to be get more people to use RAID (including MD5) and
>> try to enhance it as we go. Just using a single disk is not a good
>> thing...
>
> Yep; the solution is to improve the storage devices.  It is *not* to
> encourage people to think RAID is not worth it, or that somehow ext2
> is better than ext3 because it runs fsck's all the time at boot up.
> That's just crazy talk.
>
> 						- Ted

Agreed....

ric
