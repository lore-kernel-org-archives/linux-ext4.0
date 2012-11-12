From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: Sun, 11 Nov 2012 22:37:33 -0600
Message-ID: <50A07D0D.9080101@redhat.com>
References: <20121111222716.11311.qmail@science.horizon.com> <FF74F654-B6E0-4BF9-A3FC-C2077275B542@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab2KLEhi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Nov 2012 23:37:38 -0500
In-Reply-To: <FF74F654-B6E0-4BF9-A3FC-C2077275B542@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/11/12 7:54 PM, Andreas Dilger wrote:
> On 2012-11-11, at 3:27 PM, George Spelvin wrote:
>> I'm using v1.43-WIP-2012-09-22-10-g41bf599, last commit Oct. 14.
>>
>> I'm trying to create a file system with 64bit support and specify a
>> maximum resize limit of 64 TiB = 2^34 blocks = 17179869184.
>>
>> (gdb) run -n -t ext4 -O 64bit -E resize=4294967296 /dev/md1
>> Starting program: /root/e2fsprogs/misc/mke2fs -n -t ext4 -O 64bit -E resize=4294967295 /dev/md1
>> [Thread debugging using libthread_db enabled]
>> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
>> mke2fs 1.43-WIP (22-Sep-2012)
>>
>> Program received signal SIGFPE, Arithmetic exception.
>> 0x0000000000405f5a in parse_extended_opts (opts=<optimized out>, 
>>   param=0x64e200) at mke2fs.c:800
>> 800                             gdpb = EXT2_DESC_PER_BLOCK(param);
> 
> This is definitely a bug in the code to do a divide-by-zero.
> 
> However, it should be pointed out that the "resize" option does not
> make sense for filesystems larger than 16TB.  The mechanism used for
> resizing beyond 16TB is different and does not need to reserve blocks.

In fairness to the reporter, nothing in the existing ext4 documentation,
AFAICT, mentions this.  (but then -O 64bit isn't really documented at all)

And given that the poor reporter is re-making his whole filesystem just
because he found out that he can't grow past 16T:
	"(wow, was *that* a nasty surprise)"
it's understandable that he's trying to give it a rather large resize=
value this time around.

This is one of those dark corners of weird behavior that could really use
some formal docs, at least.  :(

-Eric

> Cheers, Andreas.
> 
>> The issue is that 
>>
>> #define EXT2_DESC_PER_BLOCK(s)          (EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
>> #define EXT2_DESC_SIZE(s)                                                \
>>      ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
>>       (s)->s_desc_size : EXT2_MIN_DESC_SIZE)
>>
>> and s_desc_size is 0 because parse_extended_opts is called from PRS which
>> is called very early in main() at line 2320, while s_desc_size is set up
>> in ext2fs_initialize, which is not called from main() until mke2fs.c:2353.
>>
>> As a temporary workaround, I notice that ext2fs_initialize sets s_desc_size to
>> the fixed value EXT2_MIN_DESC_SIZE_64BIT, so I changed the #define as follows:
>>
>> #define EXT2_DESC_SIZE(s)                                                \
>>      ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
>>       (s)->s_desc_size ?: EXT2_MIN_DESC_SIZE_64BIT : EXT2_MIN_DESC_SIZE)
>>
>> ... which seems to work.
>>
>>
>> (One point that occurred to me while wrestling with this is that the
>> default resize limit of initial size * 1000 should perhaps be clamped
>> to 2^32 if 64bit is not enabled.)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

