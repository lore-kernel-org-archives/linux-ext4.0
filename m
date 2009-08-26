From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 06:39:14 -0400
Message-ID: <4A9510D2.1090704__46759.9630974748$1251283418$gmane$org@redhat.com>
References: <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbZHZKjS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 06:39:18 -0400
In-Reply-To: <20090826025849.GF32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 10:58 PM, Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 09:15:00PM -0400, Ric Wheeler wrote:
>    
>> I agree with the whole write up outside of the above - degraded RAID
>> does meet this requirement unless you have a second (or third, counting
>> the split write) failure during the rebuild.
>>      
> The argument is that if the degraded RAID array is running in this
> state for a long time, and the power fails while the software RAID is
> in the middle of writing out a stripe, such that the stripe isn't
> completely written out, we could lose all of the data in that stripe.
>
> In other words, a power failure in the middle of writing out a stripe
> in a degraded RAID array counts as a second failure.
>    
> To me, this isn't a particularly interesting or newsworthy point,
> since a competent system administrator who cares about his data and/or
> his hardware will (a) have a UPS, and (b) be running with a hot spare
> and/or will imediately replace a failed drive in a RAID array.
>
>         	    	       	       	 	      - Ted
>    

I agree that this is not an interesting (or likely) scenario, certainly 
when compared to the much more frequent failures that RAID will protect 
against which is why I object to the document as Pavel suggested. It 
will steer people away from using RAID and directly increase their 
chances of losing their data if they use just a single disk.

Ric
