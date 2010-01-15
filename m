From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Fri, 15 Jan 2010 12:51:31 -0500
Message-ID: <4B50AB23.8050300@redhat.com>
References: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>	 <fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com> <fa7b26051001131658ya96c3b0ieb6010c6fba389c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>
To: Mike Mestnik <cheako911@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0AORvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 12:51:17 -0500
In-Reply-To: <fa7b26051001131658ya96c3b0ieb6010c6fba389c4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/13/2010 07:58 PM, Mike Mestnik wrote:
> On Wed, Jan 13, 2010 at 6:13 PM, Mike Mestnik<cheako@visi.com>  wrote:
>    
>> What should this value be?  From what I gather it should be the length
>> of data stored on a single disk for each RAID level block.  If that's
>> the case how is it that two given data blocks are calculated to be on
>> separate drives?  It seams to me that the stripe-width is also
>> essential in this regard, but the man page does not reflect this.
>>
>> For example let's say that stride=1, then which of the following
>> blocks are not on the same drive as 1: 8 9 10?
>> The answer is dependent on the number data disks, like so.
>> Where x = n - 1 or n depending on the RAID type.
>> if x = 2 then 9
>> if x = 3 then 8 and 10
>> if x = 5 then 8 and 9
>>
>>      
> Wait!!
> I got this all wrong, one would need all of x, n, and stride to
> successfully determine the disk used for a given stride.
>
> Seams to me mkfs is missing some parameters.  What about [-g
> blocks-per-group]...
>
> http://tldp.org/HOWTO/Software-RAID-0.4x-HOWTO-8.html
>
>    

Hi Mike,

Recent changes upstream export alignment and optimal IO size for you (at 
least for software RAID/dm devices) and for some external arrays if the 
vendor exports the information in a standard way.

Martin was the lead on that & work has been ongoing to add support up 
the tool chain.

Hopefully, this will get easier to do so we all don't have to work out 
the numbers each time we build on RAID :-)

Ric

>> There is no way to make this calculation with out knowing x, further
>> more calculating x based of of both stride and stripe-width is round
>> about...  Why not simply ask for x, the number of data disks and have
>> stripe-width be the value that is calculated, as stride might not go
>> into stripe-width evenly leaving you with a headache.
>>
>> Did I locate a bug?
>>
>> Is there a better forum for this discussion?
>>
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

