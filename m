Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:51498 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbeLKL71 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2018 06:59:27 -0500
Subject: Re: [PATCH 1/2] fs: introduce APIs to enable sending write-hint
 with buffer-head
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com, axboe@kernel.dk,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com
From: Kanchan Joshi <joshi.k@samsung.com>
Message-id: <2e15501c-cbdd-aca2-19fd-4519093cacab@samsung.com>
Date: Tue, 11 Dec 2018 17:27:16 +0530
MIME-version: 1.0
In-reply-to: <20181210134949.GL29289@quack2.suse.cz>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
        <CGME20181210125251epcas1p3023db72cc08d6b2f899141d551d53f61@epcas1p3.samsung.com>
        <1544446204-5291-2-git-send-email-joshi.k@samsung.com>
        <20181210134949.GL29289@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you for review and suggestion.
I will make that change in V2, once things become clear for second patch
of this set.

On Monday 10 December 2018 07:19 PM, Jan Kara wrote:
> On Mon 10-12-18 18:20:03, Kanchan Joshi wrote:
>> submit_bh and write_dirty_buffer do not take write-hint as
>> parameter. This patch introduces variants which do.
>>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> 
> ...
> 
>> @@ -3162,6 +3169,20 @@ void write_dirty_buffer(struct buffer_head *bh, int op_flags)
>>   }
>>   EXPORT_SYMBOL(write_dirty_buffer);
>>   
>> +void write_dirty_buffer_write_hint(struct buffer_head *bh, int op_flags,
>> +				   enum rw_hint hint)
>> +{
>> +	lock_buffer(bh);
>> +	if (!test_clear_buffer_dirty(bh)) {
>> +		unlock_buffer(bh);
>> +		return;
>> +	}
>> +	bh->b_end_io = end_buffer_write_sync;
>> +	get_bh(bh);
>> +	submit_bh_wbc(REQ_OP_WRITE, op_flags, bh, hint, NULL);
>> +}
>> +EXPORT_SYMBOL(write_dirty_buffer_write_hint);
>> +
> 
> Please implement write_dirty_buffer() as a call to
> write_dirty_buffer_write_hint() so that we don't unnecessarily duplicate
> the code. Otherwise the patch looks good.
> 
> 								Honza
> 
