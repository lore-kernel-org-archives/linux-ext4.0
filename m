From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 18 Oct 2007 19:05:55 -0700
Message-ID: <1192759555.3776.28.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
	 <1191285346.11737.58.camel@localhost.localdomain>
	 <20071004131207.65406a7b.akpm@linux-foundation.org>
	 <20071011111849.GC7125@duck.suse.cz>
	 <20071017210925.c3c66de5.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sho@tnes.nec.co.jp, clameter@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34309 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965886AbXJSCGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 22:06:19 -0400
In-Reply-To: <20071017210925.c3c66de5.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-17 at 21:09 -0700, Andrew Morton wrote:
> On Thu, 11 Oct 2007 13:18:49 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > With 64KB blocksize, a directory entry can have size 64KB which does not fit
> > into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> > value when read from / written to disk.
> 
> btw, this changes ext2's on-disk format.
> 
Just to clarify this is only changes the directory entries format on
ext2/3/4 fs with 64k block size. But currently without kernel changes
ext2/3/4 does not support 64 block size.

> a) is the ext2 format documented anywhere?  If so, that document will
>    need updating.
> 

The e2fsprogs needs to be changed to sync up with this change.

Ted has a paper a while back to show ext2 disk format 
http://web.mit.edu/tytso/www/linux/ext2intro.html

The Documentation/filesystems/ext2.txt doesn't have the ext2 format
documented. That document is out-dated need to be reviewed and cleaned
up.
 
> b) what happens when an old ext2 driver tries to read and/or write this
>    directory entry?  Do we need a compat flag for it?
> 
> c) what happens when old and new ext3 or ext4 try to read/write this
>    directory entry?
> 

Without the first patch in this series: ext2 large blocksize support
patches, it fails to mount a ext2 filesystem with 64k block size. 

[PATCH 1/2] ext2:  Support large blocksize up to PAGESIZE
http://lkml.org/lkml/2007/10/1/361

So the old ext2/3/4 driver will not get access the directory entry with
64k block size format changes.


Regards,

Mingming

> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
