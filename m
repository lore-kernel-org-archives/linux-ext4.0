From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence (and flags)
Date: Thu, 23 Jul 2009 14:01:33 -0700
Message-ID: <1248382893.14764.8.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248378517.8421.4.camel@bobble.smo.corp.google.com>
	 <4A68C9EC.4050301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:35181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZGWWqZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 18:46:25 -0400
In-Reply-To: <4A68C9EC.4050301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-07-23 at 15:37 -0500, Eric Sandeen wrote:
> I'm confused (again?) :).  I don't see FS_FALLOC_FL in the latest kernel
> source, and ext2 (well, my ext2 anyway) can't do fallocate().  Google
> (well, my google search) can't find it either.  Is this something in
> your tree?

No, I'm the one who got confused, yes, that's part of a hack in our
tree.

You did answer my question, though, at least partly:

> As for:
> 
> #define EXT4_EXT_MIGRATE                0x00100000 /* Inode is migrating */
> 
> this is not in the mask that FS_IOC_GETFLAGS can see ... and I don't
> think anyone else uses FS_DIRECTIO_FL.
> 
> I'm not sure if the flags not in FS_FL_USER_VISIBLE are supposed to be
> fs-unique.

The flag will need to be generic in any case, since inode_setattr() has
to look at it when it's deciding whether or not to call vmtruncate().
Other filesystems that properly implement fallocate() may want to use it
for this purpose as well.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

