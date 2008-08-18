From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [2.6 patch] FS_MBCACHE: don't needlessly make it built-in
Date: Sun, 17 Aug 2008 22:20:05 -0500
Message-ID: <48A8EA65.9090204@redhat.com>
References: <20080803184325.GC7442@cs181140183.pp.htv.fi> <20080817190431.GG4199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Adrian Bunk <bunk@kernel.org>,
	Andreas Gruenbacher <agruen@suse.de>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYHRDW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Aug 2008 23:22:26 -0400
In-Reply-To: <20080817190431.GG4199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Aug 03, 2008  21:43 +0300, Adrian Bunk wrote:
>> Assume you have:
>> - one or more of ext2/3/4 statically built into your kernel
>> - none of these with extended attributes enabled and
>> - want to add onother one of ext2/3/4 modular and with
>>   extended attributes enabled
>>
>> then you currently have to reboot to use it since this results in 
>> CONFIG_FS_MBCACHE=y.
>>
>> That's not a common issue, but I just ran into it and since there's no 
>> reason to get a built-in mbcache in this case this patch fixes it.
> 
> To be honest, I'd like an option to disable MBCACHE entirely.  This
> code is of no use if the EAs on an inode are not identical (i.e. if
> anything other than ACLs are in use)

or selinux....

> and is also not useful if the
> xattrs fit into the large inodes in ext4 (and ext3 if the filesystem
> is formatted with this option).

... which is now the default.

a config option sounds reasonable to me, too.  I think by the time EAs
spill out of the inode, the chance of them being identical is pretty
small?  (i.e. a single acl set, or selinux context may be common, but if
you have enough to not fit in the inode it's more likely to be a
mishmash of things?)

-Eric


> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

