From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Wed, 03 Sep 2008 10:08:04 -0400
Message-ID: <48BE9A44.10103@redhat.com>
References: <20080827210636.GC26987@mit.edu> <1219871676-18456-1-git-send-email-tytso@mit.edu> <1219871676-18456-2-git-send-email-tytso@mit.edu> <1219917321.3591.79.camel@frecb007923.frec.bull.fr> <20080828133449.GG26987@mit.edu> <48B6AACE.6060103@redhat.com> <20080828143648.GJ26987@mit.edu> <48B6B86F.5060106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	=?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4@vger.kernel.org
To: rwheeler@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbYICOLj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2008 10:11:39 -0400
In-Reply-To: <48B6B86F.5060106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> Theodore Tso wrote:
>> On Thu, Aug 28, 2008 at 09:40:30AM -0400, Ric Wheeler wrote:
>>  
>>> I can try and test this with my fsync() heavy fs_mark run...
>>>
>>>     
>>
>> Given [1] I have no doubt that you should see a difference between
>> mke2fs from e2fsprogs 1.41.0 (which will allocate the journal at the
>> beginning of the filesystem) and the latest tip of e2fsprogs.
>>
>> It would be interesting to see how measurable the difference is,
>> though.  I'd recommend doing "mke2fs -t ext4dev" using both versions
>> of mke2fs, and seeing how much the difference it makes.
>>
>> [1] 
>> http://www.usenix.org/events/usenix05/tech/general/full_papers/prabhakaran/prabhakaran_html/main.html#fig-journal-location-withinfs-fix 
>>
>>
>>                             - Ted
>>
>>   
>
> I was thinking of trying this on a much larger disk (1TB) - the 
> article reports on a 4GB partition which is pretty tiny,
>
> ric
Using Ted's new journal in the middle mkfs & hacking it slightly to make 
the journal go back to block 0, I ran some quick tests to try and 
measure an impact of the journal placement (multiple threads writing 4MB 
files).

The results that are most clear are certainly that delayed allocation is 
a big win, the journal placement has mostly a positive impact on the 
write performance, but the results are quite close.


Starting with a newly created file system, each pass put down 16,000 4MB 
files:


 Count     Files/sec - ZERO    Files/sec - Middle
 16000         20.8                   20.8
 32000         19.2                   18.4
 48000         16.0                   14.4
 64000         20.8                   20.8
 80000         20.8                   20.8
 96000         20.8                   20.8
112000         20.8                   20.8
128000         19.2                   20.8
144000         19.2                   19.2
160000         17.6                   19.2
176000         16.6                   17.6
192000         16.0                   16.0
208000         14.4                   14.4
224000         12.8                   14.4


With no delayed allocation:

Count     Files/sec - ZERO    Files/sec - Middle
 16000         16.0                   16.0
 32000         16.0                   16.0
 48000         16.0                   16.0
 64000         16.0                   14.8
 80000         14.4                   14.4
 96000         14.1                   14.4
112000         12.8                   12.8
128000         11.2                   11.2
144000         11.2                   12.8
160000         14.4                   14.4
176000         11.3                   12.8
192000         14.9                   12.8
208000         16.0                   16.0
224000         14.4                   16.0

ric

