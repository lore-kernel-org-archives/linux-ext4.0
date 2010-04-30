From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Fri, 30 Apr 2010 15:40:14 -0600
Message-ID: <C968C336-E9B4-41A1-96DE-E264827F936E@oracle.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de> <201004291014.07194.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54725 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0D3VmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 17:42:18 -0400
In-Reply-To: <20100430143319.d51d6d77.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-04-30, at 15:33, Andrew Morton wrote:
> On Thu, 29 Apr 2010 10:14:06 +0530
> Nikanth Karthikesan <knikanth@suse.de> wrote:
>> diff --git a/fs/open.c b/fs/open.c
>> index 74e5cd9..4ca57c9 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -405,17 +405,26 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>> 	if (S_ISFIFO(inode->i_mode))
>> 		return -ESPIPE;
>> 
>> -	/*
>> -	 * Let individual file system decide if it supports preallocation
>> -	 * for directories or not.
>> -	 */
>> -	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>> -		return -ENODEV;
>> -
>> -	/* Check for wrap through zero too */
>> -	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
>> +	/* Check for wrap through zero */
>> +	if (offset+len < 0)
>> 		return -EFBIG;
> 
> I suggest that this test be moved up to where the function tests `if
> (offset < 0 || len <= 0)' - it seems more logical.

Sometimes the order of these checks is mandated by POSIX because of the error return code.  I'm not saying for sure that is the case here, but sometimes logic doesn't come into the specification. :-/

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

