From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious unsigned
 wrap
Date: Wed, 03 Dec 2008 09:32:18 -0500
Message-ID: <49369872.20406@tmr.com>
References: <49343AD9.4020606@gmail.com> <20081202220510.ddef1115.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: roel kluin <roel.kluin@gmail.com>, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:55219 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYLCOdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 09:33:23 -0500
In-Reply-To: <20081202220510.ddef1115.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Mon, 01 Dec 2008 14:28:25 -0500 roel kluin <roel.kluin@gmail.com> wrote:
>
>   
>> Fix loop, with obvious unsigned wrap
>>
>>     
>
> Please raise separate patches for ext3 and ext4 - their paths into the
> tree are different.
>
>   
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>>  	/* Split the existing block in the middle, size-wise */
>>  	size = 0;
>>  	move = 0;
>> -	for (i = count-1; i >= 0; i--) {
>> +	for (i = count; i--; ) {
>>     
>
> So we're replacing an accidental for(;;) with something which can
> really terminate.  This is potentially a functional change, and it's
> perhaps telling us that we should replace it with a real for (;;) loop
> anyway.
>   
It's not a "for (;;)" loop, because the index value does change, but 
clearly in the current implementation the termination condition won't be 
met by any index value. You still need to bail on index value, and the 
index is used in the loop.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


