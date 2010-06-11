From: "jeff.liu" <jeff.liu@oracle.com>
Subject: Re: bug#6131: [PATCH]: fiemap support for efficient sparse file copy
Date: Fri, 11 Jun 2010 16:31:13 +0800
Message-ID: <4C11F451.8040304@oracle.com>
References: <4BE41FFF.4020809@oracle.com>	<871vdho68j.fsf@meyering.net>	<4BEC0BCC.3080906@oracle.com>	<87k4qyl6lw.fsf@meyering.net>	<4BF683CC.3060407@oracle.com>	<4BF6ABE7.3020600@oracle.com>	<877hmpeivx.fsf@meyering.net>	<4BFF763A.9010205@oracle.com>	<8763286kni.fsf@meyering.net>	<4C0275FA.1030901@oracle.com>	<874ohpywri.fsf@meyering.net>	<87y6exuc5i.fsf@meyering.net>	<874ohdu5b8.fsf@meyering.net>	<87eighs1t9.fsf@meyering.net>	<4C0FA93C.6020205@oracle.com>	<87iq5sp7eg.fsf@meyering.net>	<4C108CB9.8010805@oracle.com> <4C11798B.6090500@cs.ucla.edu> <4C1183FD.9010502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: bug-coreutils@gnu.org, Joel Becker <Joel.Becker@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tao Ma <tao.ma@oracle.com>
To: Sunil Mushran <sunil.mushran@oracle.com>,
	Paul Eggert <eggert@CS.UCLA.EDU>,
	Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:16776 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0FKIdK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jun 2010 04:33:10 -0400
In-Reply-To: <4C1183FD.9010502@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sunil Mushran wrote:
> On 06/10/2010 04:47 PM, Paul Eggert wrote:
>> On 06/09/2010 11:56 PM, jeff.liu wrote:
>>   
>>> Yeah, I just realized that the behaviour I observed is caused by the
>>> delay allocation mechanism of
>>> the particular FS.
>>>      
>> If the file system is using delayed allocation, then can
>> the fiemap ioctl tell us that a file contains a hole (because nothing
>> has been
>> allocated there), but read() would tell us that the file contains
>> nonzero data at the same location
>> (because it's sitting in a buffer somewhere)?  If so, we'd need to do
>> something like invoke
>> fdatasync() on the file before issuing the fiemap ioctl, to force
>> allocation; or perhaps
>> there's another ioctl that will do the allocation without having to
>> actually do a sync.
>>    
> 
> I guess we'll have to use FIEMAP_FLAG_SYNC.
Hi Sunil,

Thanks for the comments.
So we can ensure the source file synced before mapping in this way.

Hi Jim and Paul,

How about the tiny patch below?

>From d6d619a169ff68a9a310a69d8089b9fbf83b5f91 Mon Sep 17 00:00:00 2001
From: Jie Liu <jeff.liu@oracle.com>
Date: Fri, 11 Jun 2010 16:29:02 +0800
Subject: [PATCH 1/1] copy.c: add FIEMAP_FLAG_SYNC to fiemap ioctl

* src/copy.c (fiemap_copy): Force kernel to sync the source
file before mapping.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 src/copy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index f149be4..f48c74d 100644
--- a/src/copy.c
+++ b/src/copy.c
@@ -191,6 +191,7 @@ fiemap_copy (int src_fd, int dest_fd, size_t buf_size,
   do
     {
       fiemap->fm_length = FIEMAP_MAX_OFFSET;
+      fiemap->fm_flags = FIEMAP_FLAG_SYNC;
       fiemap->fm_extent_count = count;

       /* When ioctl(2) fails, fall back to the normal copy only if it
-- 
1.5.4.3



Thanks,
-Jeff

> 
>> There's also the issue of copying from a file at the same time that
>> some other process
>> is writing to it, but that is allowed to produce ill-defined
>> behavior.  I'm more worried
>> about the case where some other process writes to the source file just
>> before 'cp' starts.
>>    
> 
> cp's behavior with active files is undefined. But we know it reads from
> offset 0 to MAX. With fiemap it will continue to do the same with the
> exception that it will skip reads (and thus writes) depending on the extent
> map it gets at the very beginning.
> 
>> (Sorry, I haven't had time yet to dive into the proposed change; I'm
>> still trying to understand
>> the environment.)
>>
>> One other thing: Solaris 10 supports lseek with the SEEK_HOLE and
>> SEEK_DATA options, which
>> are easier to use and which (as far as I can tell from the manual)
>> shouldn't require anything
>> fdatasync-ish.  Any objection if I propose support for that too?  It
>> is supposed to work
>> with ZFS, something I can test here.
>>    
> 
> There is no plan to implement SEEK_HOLE/SEEK_DATA in the kernel.
> At most glibc will use fiemap to extend lseek(). BTW, SEEK_HOLE/DATA
> also have the same problem with active files.
> 
> ccing linux-ext4.
> 
> 
> 


-- 
With Windows 7, Microsoft is asserting legal control over your computer and is using this power to
abuse computer users.
