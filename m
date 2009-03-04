From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Wed, 4 Mar 2009 01:36:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr> <49ADBB03.9070303@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, kzak@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZCDAgr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 19:36:47 -0500
In-Reply-To: <49ADBB03.9070303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wednesday 2009-03-04 00:19, Eric Sandeen wrote:
>> 
>> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
>> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
>> would mean the default for -i is 16384. 
>
>That's right, look in /etc/mke2fs.conf:
>
>[defaults]
>        base_features =
>sparse_super,filetype,resize_inode,dir_index,ext_attr
>        blocksize = 4096
>        inode_size = 256
>        inode_ratio = 16384

Interesting - thanks for the hint.

>> Besides me finding 16384 a 
>> little unreasonable (XFS offers 2M inodes by default), 
>
>XFS is a totally different beast, because it dynamically allocates
>inodes.  It doesn't really offer *anything* by default.
>
>Which part of a 16384-data-bytes-to-inode-count ratio do you find
>unreasonable?  Do you find it unreasonably high, or unreasonably low?

I think it's a bit too high, causing the amount of usable inodes
to be a bit too low. 

>> the big 
>> point is that the mke2fs manpage (belonging to util-linux, hence Cc) 
>
>not so much:
>$ rpm -qf /usr/share/man/man8/mke2fs.8.gz
>e2fsprogs-1.41.3-2.fc10.x86_64

Sorry, I had looked for man8/mkfs.ext2.8.gz. I am not quite sure
what makes some developers deviate(*) from the mkfs.$name/fsck.$name
scheme ;-)

(*) e2, reiser(3), dosfs

>> does not mention this 16384 default.
>> Hope this can be addressed.
>
>You could send a patch :)

parent b2ca48f40eb33bd86b8d53d4373e7fce96bced4a (v1.41.4)
commit ca28058c4004ceaa42edeb6ba61bc2aa53d7c03d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Mar 4 01:36:09 2009 +0100

doc: mention default for mke2fs -i

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 misc/mke2fs.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 1605895..38ddf6d 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -276,7 +276,7 @@ be smaller than the blocksize of the filesystem, since in that case more
 inodes would be made than can ever be used.  Be warned that it is not
 possible to expand the number
 of inodes on a filesystem after it is created, so be careful deciding the
-correct value for this parameter.
+correct value for this parameter. The default value is 16384.
 .TP
 .BI \-I " inode-size"
 Specify the size of each inode in bytes.
-- 
# Created with git-export-patch
