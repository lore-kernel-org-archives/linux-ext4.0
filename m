From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: try fast merge operation in ext4_mb_free_metadata()
Date: Thu, 25 Mar 2010 22:11:56 +0800
Message-ID: <ac8f92701003250711l5d2d3372y6058277ed08d334c@mail.gmail.com>
References: <ac8f92701003240632t2bcdb0b4l1d7543e3b1ffc9e7@mail.gmail.com>
	 <87bpedd520.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:51483 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0CYOL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 10:11:58 -0400
Received: by ywh2 with SMTP id 2so3381955ywh.33
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 07:11:57 -0700 (PDT)
In-Reply-To: <87bpedd520.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/25, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> On Wed, 24 Mar 2010 21:32:39 +0800, jing zhang <zj.barak@gmail.com> wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Wed Mar 24 21:30:22     2010
>>
>> There may exist fast path for merge if merge-able.
>>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger@sun.com>
>> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
>>
>> ---
>>
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc7.c	2010-03-24 21:27:24.000000000 +0800
>> @@ -4385,6 +4385,24 @@ ext4_mb_free_metadata(handle_t *handle,
>>  		}
>>  	}
>>
>> +	if (parent) {
>> +		/* let's try fast path */
>> +		entry = rb_entry(parent, struct ext4_free_data, node);
>> +		if (n == &parent->rb_left) {
>> +			if (can_merge(new_entry, entry)) {
>> +				entry->start_blk = new_entry->start_blk;
>> +				entry->count += new_entry->count;
>> +				/* and info the caller that new_entry is
>> +				 * not used yet.
>> +				 */
>> +				return 0;
>
> return 0 on success so you may want -1 here

Agree.

      - zj

>
>> +			}
>> +		}
>> +		else if (can_merge(entry, new_entry)) {
>> +			entry->count += new_entry->count;
>> +			return 0;
>> +		}
>> +	}
>>  	rb_link_node(new_node, parent, n);
>>  	rb_insert_color(new_node, &db->bb_free_root);
>> --
>
> -aneesh
>
