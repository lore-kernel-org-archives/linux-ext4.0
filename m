From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: page_cache pages not released in
	ext4_mb_load_buddy()
Date: Thu, 25 Mar 2010 22:02:44 +0800
Message-ID: <ac8f92701003250702u4d98bbe3n3d486e462de192af@mail.gmail.com>
References: <ac8f92701003240721l7a7079dnd9cbd55526cd1788@mail.gmail.com>
	 <87eij9d5qs.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:44660 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0CYOCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 10:02:45 -0400
Received: by gxk9 with SMTP id 9so2149827gxk.8
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 07:02:44 -0700 (PDT)
In-Reply-To: <87eij9d5qs.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/25, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> On Wed, 24 Mar 2010 22:21:01 +0800, jing zhang <zj.barak@gmail.com> wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Wed Mar 24 20:38:48     2010
>>
>> If ext4_mb_init_cache() returns error, there is no page_cache_release()
>> issued.
>>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger@sun.com>
>> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
>>
>> ---
>>
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc-9.c	2010-03-24 22:24:56.000000000 +0800
>> @@ -1132,8 +1132,6 @@ repeat_load_buddy:
>>  	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
>>  	mark_page_accessed(page);
>>
>> -	BUG_ON(e4b->bd_bitmap_page == NULL);
>> -	BUG_ON(e4b->bd_buddy_page == NULL);
>
> Why remove these ?

Just before return successfully, both bitmap page and buddy page are assigned.
If not either, EIO will branch.

>
>>
>>  	return 0;
>>
>> @@ -1142,6 +1140,8 @@ err:
>>  		page_cache_release(e4b->bd_bitmap_page);
>>  	if (e4b->bd_buddy_page)
>>  		page_cache_release(e4b->bd_buddy_page);
>> +	if (page)
>> +		page_cache_release(page);
>>  	e4b->bd_buddy = NULL;
>>  	e4b->bd_bitmap = NULL;
>
> Can you add a comment which says on error page will point to the page
> cache page which haven't been assigned to neither bd_bitmap_page or
> bd_buddy_page

+	if (page)
+            /* we have to release page here in case that
+             * ext4_mb_init_cache() returns error when preparing
+             * either bitmap_ or buddy_page.
+             */
+		page_cache_release(page);

>
> But good catch !!
>
> -aneesh
>

Is that ok, Aneesh?

        - zj
