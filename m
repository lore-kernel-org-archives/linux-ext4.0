From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: setattr: Forbid setting data journalling when
 delalloc enabled
Date: Mon, 9 Jan 2012 17:22:24 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1201091719220.8881@dhcp-27-109.brq.redhat.com>
References: <1326123903-21040-1-git-send-email-lczerner@redhat.com> <20120109155504.GE22175@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178Ab2AIQWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 11:22:31 -0500
In-Reply-To: <20120109155504.GE22175@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 Jan 2012, Ted Ts'o wrote:

> On Mon, Jan 09, 2012 at 04:45:03PM +0100, Lukas Czerner wrote:
> > Ext4 does not support data journalling with delayed allocation enabled.
> > We even does not allow to mount the file system with delayed allocation
> > and data journalling enabled, but it can be set via FS_IOC_SETFLAGS
> > which is wrong.
> > 
> > When data journalling and delayed allocation is enabled it can lead to
> > troubles. Here is one example how to reproduce an oops:
> > 
> >  mkfs.ext4 /dev/sdd
> >  mount /dev/sdd /mnt/test1
> >  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
> >  chattr +j /mnt/test1/file
> >  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
> >  chattr -j /mnt/test1/file
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Don't we also need to add a check in ext4_should_journal_data() in
> fs/ext4/ext4_jbd2.h?  Otherwise we could get in trouble if the data
> journalling flag had been set previously when the file system was
> mounted nodelalloc.

Ah, of course you're right. We should add a check into
ext4_should_journal_data().

> 
> In fact it could be argued that we don't need to return EOPNOSUPP, or
> printk a message, but simply make sure that the data journal flag is
> ignored in if delayed allocation is enabled.  If that's true, we can
> allow the user to set or clear the journal flag as much as they like;
> it would just be ignored.

I am fine with ignoring the flag silently without any information for
the user that the flag will be ignored when delalloc is enabled. After
all it should be clear from documentation that we do not allow data
journalling and delayed allocation together.

Thanks!

-Lukas

> 
> Thanks,
> 
> 					- Ted
> 

-- 
