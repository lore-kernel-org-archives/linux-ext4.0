From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 17:19:55 -0500
Message-ID: <48A35E0B.5050907@redhat.com>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu> <200808132307.07437.mail@eworm.de> <20080813220100.GE6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christian Hesse <mail@eworm.de>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYHMWUD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 18:20:03 -0400
In-Reply-To: <20080813220100.GE6142@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 11:07:06PM +0200, Christian Hesse wrote:
>> Please look at the bottom of my last two mails... That was with your patch 
>> applied.
> 
> Sorry, I missed it.  The new BUG seems to be a bug in the delayed
> allocation code, specifically here, in fs/ext4/inode.c:ext4_da_release_space():
> 
> 	   /* figure out how many metablocks to release */
> 	   BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> 	   mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
> 
> I've quickly looked at the code, and how i_reserved_meta_blocks gets
> updated, and nothing *obviously* wrong is jumping out at me.  Anyone
> else have time to investigate this a bit more deeply?

I don't :), but I tried a quick reproducer anyway and couldn't hit it ...

mkfs.ext3, mount, create non-extents file
umount, tune2fs to ext4
mount as ext4, write to file, open file O_TRUNC

... didn't oops for me :(

-Eric
