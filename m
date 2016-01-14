From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] resize2fs: clear uninit BG if allocating from new
 group
Date: Thu, 14 Jan 2016 13:26:22 -0600
Message-ID: <5697F65E.20201@redhat.com>
References: <55FB41CA.8010003@redhat.com> <5697ECEB.3020408@redhat.com>
 <20160114185043.GA5749@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbcANT0X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jan 2016 14:26:23 -0500
In-Reply-To: <20160114185043.GA5749@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/14/16 12:50 PM, Darrick J. Wong wrote:
> On Thu, Jan 14, 2016 at 12:46:03PM -0600, Eric Sandeen wrote:
...

>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
>> index 86d860f..0dca002 100644
>> --- a/lib/ext2fs/ext2fs.h
>> +++ b/lib/ext2fs/ext2fs.h
>> @@ -647,6 +647,7 @@ static inline int ext2fs_needs_large_file_feature(unsigned long long file_size)
>>  }
>>  
>>  /* alloc.c */
>> +extern void clear_block_uninit(ext2_filsys fs, dgrp_t group);
> 
> If you're going to expose this as a new API call then this needs to be
> ext2fs_clear_block_uninit().

Hm, yes.  I tried to work around it but don't see a nice way.

> (Do we want a flags arg just in case we ever need one?)

No.  ;)

(EXT2_CLEAR_GROUP_UNINIT_HALFWAY?  I can't really think of any reasonable
variation on "clear this group's uninit status")

-Eric
