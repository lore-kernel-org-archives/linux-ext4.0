From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Accomodate 32-bit uid/guid values in e2fsprogs
Date: Tue, 08 May 2007 00:05:34 -0500
Message-ID: <4640051E.4040703@redhat.com>
References: <463F5D8D.7080201@redhat.com> <20070508042813.GD10940@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967844AbXEHFFi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 May 2007 01:05:38 -0400
In-Reply-To: <20070508042813.GD10940@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, May 07, 2007 at 12:10:37PM -0500, Eric Sandeen wrote:
>> e2fsprogs doesn't handle large (> 16 bit) UID/GID...
> 
> Applied, with one correction:
> 
>> --- e2fsprogs-hg.orig/misc/mke2fs.c
>> +++ e2fsprogs-hg/misc/mke2fs.c
>> @@ -492,9 +494,14 @@ static void create_root_dir(ext2_filsys 
>>  				_("while reading root inode"));
>>  			exit(1);
>>  		}
>> -		inode.i_uid = getuid();
>> -		if (inode.i_uid)
>> -			inode.i_gid = getgid();
>> +		uid = getuid();
>> +		inode.i_uid = uid;
>> +		inode.i_uid_high = uid >> 16;
>> +		if (inode.i_uid) {
> 		    ^^^^^^^^^^^
> 
> This should be "uid" instead.  Otherwise, the gid won't be set if the
> uid is a multiple of 65536.
> 
> 						- Ted

Doh... dumb mistake.  nice catch.  thanks.

-Eric
