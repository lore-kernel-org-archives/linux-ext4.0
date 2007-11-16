From: Wendy Cheng <wcheng@redhat.com>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Thu, 15 Nov 2007 22:47:40 -0500
Message-ID: <473D12DC.8090907@redhat.com>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2> <20071115185919.7df4cda9.akpm@linux-foundation.org>
Reply-To: wcheng@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbXKPDbj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2007 22:31:39 -0500
In-Reply-To: <20071115185919.7df4cda9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:

>On Fri, 16 Nov 2007 11:47:27 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>  
>
>>Currently fdatasync is identical to fsync in ext3,4.
>>I think fdatasync should skip journal flush in data=ordered and data=writeback mode
>>because this syscall is not required to synchronize the metadata.
>>    
>>
>
>I suppose so.  Although one wonders what earthly point there is in syncing
>a file's data if we haven't yet written out the metadata which is required
>for locating that data.
>
>IOW, fdatasync() is only useful if the application knows that it is overwriting
>already-instantiated blocks.
>
>In which case it might as well have used fsync().  For ext2-style filesystems,
>anyway.
>
>hm.  It needs some thought.
>
>  
>

There are non-trivial amount of performance critical programs, 
particularly in financial application segment ported from legacy UNIX 
platforms, know the difference between fsync() and fdatasync(). Those 
can certainly take advantages of this separation. Don't underestimate 
the talents of these application programmers.

-- Wendy
