From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH V2 3/3] ext4: quota handling for delayed allocation
Date: Tue, 04 Nov 2008 20:35:08 -0800
Message-ID: <4911227C.1060908@oracle.com>
References: <1225488451.7600.14.camel@mingming-laptop> <20081104173215.92ac3585.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, jack@suse.cz, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081104173215.92ac3585.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Fri, 31 Oct 2008 14:27:31 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
>> ext4: quota reservation for delayed allocation
>>
>> Index: linux-2.6.28-rc2/fs/ext4/inode.c
>> ===================================================================
>> --- linux-2.6.28-rc2.orig/fs/ext4/inode.c	2008-10-29 13:26:55.000000000 -0700
>> +++ linux-2.6.28-rc2/fs/ext4/inode.c	2008-10-30 14:25:47.000000000 -0700
>> @@ -1531,12 +1541,23 @@ repeat:
>>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>>  	total = md_needed + nrblocks;
>>  
>> +	/*
>> +	 * Make quota reservation here, to prevent quota overflow
>> +	 * later.Real quota accounting is done at pages writeout
>> +	 * time
> 
> "Make the quota reservation here to prevent quota overflow later.  Real
> quota accounting is performed and page writeout time."

s/and/at/
---

-- 
~Randy
