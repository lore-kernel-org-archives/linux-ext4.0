From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Tue, 03 Mar 2009 17:19:31 -0600
Message-ID: <49ADBB03.9070303@redhat.com>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, kzak@redhat.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZCCXTh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Mar 2009 18:19:37 -0500
In-Reply-To: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
> would mean the default for -i is 16384. 

That's right, look in /etc/mke2fs.conf:

[defaults]
        base_features =
sparse_super,filetype,resize_inode,dir_index,ext_attr
        blocksize = 4096
        inode_size = 256
        inode_ratio = 16384

> Besides me finding 16384 a 
> little unreasonable (XFS offers 2M inodes by default), 

XFS is a totally different beast, because it dynamically allocates
inodes.  It doesn't really offer *anything* by default.

Which part of a 16384-data-bytes-to-inode-count ratio do you find
unreasonable?  Do you find it unreasonably high, or unreasonably low?

> the big 
> point is that the mke2fs manpage (belonging to util-linux, hence Cc) 

not so much:
$ rpm -qf /usr/share/man/man8/mke2fs.8.gz
e2fsprogs-1.41.3-2.fc10.x86_64

> does not mention this 16384 default.
> Hope this can be addressed.

You could send a patch :)

-Eric
