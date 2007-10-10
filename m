From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS
 is not set
Date: Wed, 10 Oct 2007 10:22:49 +1000
Message-ID: <470C1B59.1060905@au1.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>	 <20071009061101.666614585@au1.ibm.com> <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:34178 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXJJAXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 20:23:53 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9A0NkuS027340
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:23:46 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9A0RKqx243186
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:27:20 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9A0NUYE008375
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:23:30 +1000
In-Reply-To: <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
> On Tue, 2007-10-09 at 15:50 +1000, markn@au1.ibm.com wrote:
>> plain text document attachment (ext4-add-init_ext4_proc-stub.patch)
>> init_ext4_fs() calls init_ext4_proc() so we need a stub init_ext4_proc()
>> for the case that CONFIG_PROC_FS is not set.
>> Without the stub we get a build error:
>>
>> fs/ext4/mballoc.c: In function 'init_ext4_proc':
>> fs/ext4/mballoc.c:2837: error: 'proc_root_fs' undeclared (first use in this function)
>> fs/ext4/mballoc.c:2837: error: (Each undeclared identifier is reported only once
>> fs/ext4/mballoc.c:2837: error: for each function it appears in.)
>>
>> Add a stub init_ext4_proc() function that does nothing but return 0
>>
>> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
>> ---
>>  fs/ext4/mballoc.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> Index: ext4/fs/ext4/mballoc.c
>> ===================================================================
>> --- ext4.orig/fs/ext4/mballoc.c
>> +++ ext4/fs/ext4/mballoc.c
>> @@ -2825,6 +2825,7 @@ static int ext4_mb_destroy_per_dev_proc(
>>  	return 0;
>>  }
>>  
>> +#ifdef CONFIG_PROC_FS
>>  int __init init_ext4_proc(void)
>>  {
>>  	ext4_pspace_cachep =
>> @@ -2840,6 +2841,12 @@ int __init init_ext4_proc(void)
>>  
>>  	return 0;
>>  }
>> +#else
>> +int __init init_ext4_proc(void)
>> +{
>> +	return 0;
>> +}
>> +#endif
>>  
>>  void exit_ext4_proc(void)
>>  {
> 
> Nope. I don't think we can do this :(
> 
> For example, we need to create ext4_pspace_cachep kmem cache 
> for the pre-allocation to work. We can't ifdef it out.

This is definitely something I'll leave to the experts then :)
At least you guys know about this now I guess.

Sorry again Andrew.


Thanks all!

Mark.

> 
> Mingming/Amit, can you take a look at this ? It looks like
> we NEED procfs support to make mballoc work. If so, we need
> to add it to the dependency.
> 
> 
> Thanks,
> Badari
> 
