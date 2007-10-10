From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: [patch 2/2] move init_ext4_proc() last and add cleanup call	exit_ext4_proc()
Date: Wed, 10 Oct 2007 10:11:12 +1000
Message-ID: <470C18A0.3010409@au1.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>	 <20071009061102.363619477@au1.ibm.com> <1191946922.12131.26.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:33293 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXJJAMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 20:12:16 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9A0CC0G023665
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:12:12 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9A0Fm6w215640
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:15:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9A0BvoA030446
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:11:57 +1000
In-Reply-To: <1191946922.12131.26.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
> On Tue, 2007-10-09 at 15:50 +1000, markn@au1.ibm.com wrote:
>> plain text document attachment (ext4-move-init_ext4_proc-add-
>> cleanup.patch)
>> The first problem that is addressed is that the addition of init_ext4_proc()
>> means that the code doesn't clean up after itself on a failure of
>> init_ext4_xattr(), and the second is that usually init_*_proc() should be
>> the last thing called, so we move it to the end and add the cleanup call to
>> exit_ext4_proc().
>>
>> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
>> ---
>>  fs/ext4/super.c |    9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> Index: ext4/fs/ext4/super.c
>> ===================================================================
>> --- ext4.orig/fs/ext4/super.c
>> +++ ext4/fs/ext4/super.c
>> @@ -2999,10 +2999,6 @@ static int __init init_ext4_fs(void)
>>  {
>>  	int err;
>>  
>> -	err = init_ext4_proc();
>> -	if (err)
>> -		return err;
>> -
>>  	err = init_ext4_xattr();
>>  	if (err)
>>  		return err;
>> @@ -3012,7 +3008,12 @@ static int __init init_ext4_fs(void)
>>  	err = register_filesystem(&ext4dev_fs_type);
>>  	if (err)
>>  		goto out;
>> +	err = init_ext4_proc();
>> +	if (err)
>> +		goto out_proc;
>>  	return 0;
>> +out_proc:
>> +	exit_ext4_proc();
>>  out:
>>  	destroy_inodecache();
>>  out1:
> 
> Nope. You can not call exit_ext4_proc() if there is a failure
> in init_ext4_proc(). If the kmem_cache_create() for ext4_pspace_cachep
> fails, you would end up calling kmem_cache_destory(NULL).
> 

Oh yes, you're exactly right. Sorry, I meant to call unregister_filesystem.
(connection between brain and hands temporarily lost while typing...)

What I should have had was the following:


Subject: move init_ext4_proc() last and add unregister_filesystem() cleanup 

The addition of init_ext4_proc() means that the code doesn't clean up
after itself on a failure of init_ext4_xattr(), so move the call to
init_ext4_proc() last and then add cleanup call to unregister_filesystem().

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
 fs/ext4/super.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: ext4/fs/ext4/super.c
===================================================================
--- ext4.orig/fs/ext4/super.c
+++ ext4/fs/ext4/super.c
@@ -2999,10 +2999,6 @@ static int __init init_ext4_fs(void)
 {
 	int err;
 
-	err = init_ext4_proc();
-	if (err)
-		return err;
-
 	err = init_ext4_xattr();
 	if (err)
 		return err;
@@ -3012,7 +3008,12 @@ static int __init init_ext4_fs(void)
 	err = register_filesystem(&ext4dev_fs_type);
 	if (err)
 		goto out;
+	err = init_ext4_proc();
+	if (err)
+		goto out_filesystem;
 	return 0;
+out_filesystem:
+	unregister_filesystem(&ext4dev_fs_type);
 out:
 	destroy_inodecache();
 out1:




Sorry about the patch noise Andrew...


Thanks Badari!

Mark.


If helping turns to hindering, let me know and I'll leave you ext4 experts in peace :)

> The best way is to make init_ext4_proc() cleanup itself, in case
> of an error. Hmm.. we are not handling proc_mkdir(EXT4_ROOT) 
> failures.
> 
> Thanks,
> Badari
> 
