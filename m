From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence (and flags)
Date: Thu, 23 Jul 2009 15:37:00 -0500
Message-ID: <4A68C9EC.4050301@redhat.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>	 <4A64F37D.7020803@redhat.com>	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>	 <20090721215421.GM4231@webber.adilger.int> <1248378517.8421.4.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZGWUhK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 16:37:10 -0400
In-Reply-To: <1248378517.8421.4.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
>> That said, we might need to have some kind of flag in the on-disk
>> inode to indicate that it was preallocated beyond EOF.  Otherwise,
>> e2fsck will try and extend the file size to match the block count,
>> which isn't correct.  We could also use this flag to determine if
>> truncate needs to be run on the inode even if the new size is the
>> same.
> 
> As it happens there's already a flag, FS_FALLOC_FL, set by ext2 in
> fallocate().  Unfortunately ext4 is using that bit (0x00040000) for
> EXT4_HUGE_FILE_FL.  (Ext4 is using another bit as well, 0x00100000, for
> EXT4_EXT_MIGRATE_FL when fs.h defines it as FS_DIRECTIO_FL.)  I really
> want to use the FS_FALLOC_FL bit for this purpose but that means
> reallocating HUGE_FILE_FL to some other big.  Objections?

I'm confused (again?) :).  I don't see FS_FALLOC_FL in the latest kernel
source, and ext2 (well, my ext2 anyway) can't do fallocate().  Google
(well, my google search) can't find it either.  Is this something in
your tree?

As for:

#define EXT4_EXT_MIGRATE                0x00100000 /* Inode is migrating */

this is not in the mask that FS_IOC_GETFLAGS can see ... and I don't
think anyone else uses FS_DIRECTIO_FL.

I'm not sure if the flags not in FS_FL_USER_VISIBLE are supposed to be
fs-unique.

-Eric
