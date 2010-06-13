From: "jeff.liu" <jeff.liu@oracle.com>
Subject: Re: bug#6131: [PATCH]: fiemap support for efficient sparse file copy
Date: Sun, 13 Jun 2010 11:37:18 +0800
Message-ID: <4C14526E.9030103@oracle.com>
References: <4BE41FFF.4020809@oracle.com>	<871vdho68j.fsf@meyering.net>	<4BEC0BCC.3080906@oracle.com>	<87k4qyl6lw.fsf@meyering.net>	<4BF683CC.3060407@oracle.com>	<4BF6ABE7.3020600@oracle.com>	<877hmpeivx.fsf@meyering.net>	<4BFF763A.9010205@oracle.com>	<8763286kni.fsf@meyering.net>	<4C0275FA.1030901@oracle.com>	<874ohpywri.fsf@meyering.net>	<87y6exuc5i.fsf@meyering.net>	<874ohdu5b8.fsf@meyering.net>	<87eighs1t9.fsf@meyering.net>	<4C0FA93C.6020205@oracle.com>	<87iq5sp7eg.fsf@meyering.net>	<4C108CB9.8010805@oracle.com>	<4C11798B.6090500@cs.ucla.edu> <4C1183FD.9010502@oracle.com>	<4C11F451.8040304@oracle.com> <4C124231.7020304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Paul Eggert <eggert@CS.UCLA.EDU>, bug-coreutils@gnu.org,
	Jim Meyering <jim@meyering.net>,
	Joel Becker <Joel.Becker@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tao Ma <tao.ma@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33442 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0FMDis (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jun 2010 23:38:48 -0400
In-Reply-To: <4C124231.7020304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> jeff.liu wrote:
>> Sunil Mushran wrote:
>>> On 06/10/2010 04:47 PM, Paul Eggert wrote:
>>>> On 06/09/2010 11:56 PM, jeff.liu wrote:
>>>>   
>>>>> Yeah, I just realized that the behaviour I observed is caused by the
>>>>> delay allocation mechanism of
>>>>> the particular FS.
>>>>>      
>>>> If the file system is using delayed allocation, then can
>>>> the fiemap ioctl tell us that a file contains a hole (because nothing
>>>> has been
>>>> allocated there), but read() would tell us that the file contains
>>>> nonzero data at the same location
>>>> (because it's sitting in a buffer somewhere)?  If so, we'd need to do
>>>> something like invoke
>>>> fdatasync() on the file before issuing the fiemap ioctl, to force
>>>> allocation; or perhaps
>>>> there's another ioctl that will do the allocation without having to
>>>> actually do a sync.
>>>>    
>>> I guess we'll have to use FIEMAP_FLAG_SYNC.
>> Hi Sunil,
>>
>> Thanks for the comments.
>> So we can ensure the source file synced before mapping in this way.
>>
>> Hi Jim and Paul,
>>
>> How about the tiny patch below?
> 
> I agree that this is needed, thanks.
Thanks for your confirming response.

Regards,
-Jeff
> 
> -Eric
> 
>> From d6d619a169ff68a9a310a69d8089b9fbf83b5f91 Mon Sep 17 00:00:00 2001
>> From: Jie Liu <jeff.liu@oracle.com>
>> Date: Fri, 11 Jun 2010 16:29:02 +0800
>> Subject: [PATCH 1/1] copy.c: add FIEMAP_FLAG_SYNC to fiemap ioctl
>>
>> * src/copy.c (fiemap_copy): Force kernel to sync the source
>> file before mapping.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  src/copy.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/src/copy.c b/src/copy.c
>> index f149be4..f48c74d 100644
>> --- a/src/copy.c
>> +++ b/src/copy.c
>> @@ -191,6 +191,7 @@ fiemap_copy (int src_fd, int dest_fd, size_t buf_size,
>>    do
>>      {
>>        fiemap->fm_length = FIEMAP_MAX_OFFSET;
>> +      fiemap->fm_flags = FIEMAP_FLAG_SYNC;
>>        fiemap->fm_extent_count = count;
>>
>>        /* When ioctl(2) fails, fall back to the normal copy only if it
> 
> 
> 
> 


-- 
With Windows 7, Microsoft is asserting legal control over your computer and is using this power to
abuse computer users.
