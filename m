From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: flex_bg information initialization and question on resize/bad
 inodes with 48 bits filesystem
Date: Sat, 12 Sep 2009 10:08:43 +0200
Message-ID: <4AAB570B.70607@partition-saving.com>
References: <4AAA8F6C.6030206@partition-saving.com> <20090911183540.GB28764@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:58919 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZILIGW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Sep 2009 04:06:22 -0400
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id EDF514B0192
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2009 10:06:19 +0200 (CEST)
Received: from [192.168.103.118] (lan31-6-82-230-26-21.fbx.proxad.net [82.230.26.21])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 049DB4B00C4
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2009 10:06:16 +0200 (CEST)
In-Reply-To: <20090911183540.GB28764@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Sep 11, 2009 at 07:57:00PM +0200, Damien Guibouret wrote:
> 
>>I have looked at the new features provided by ext4 and have a question  
>>on flex_bg information initialization:
>>into ext4_fill_flex_info function of fs/ext4/super.c (lines 1698, 1700  
>>and 1702 for kernel 2.6.31) doesn't the atomic_set calls be atomic_add  
>>to sum statistics of each group composing a flex group, or do I  
>>misunderstand something ?
> 
> 
> Good eye; that's a bug; thanks for pointing that out.
> 
> 
>>For the extension to manage 48 bits blocks number, I do not see anything  
>>to treat this for resize and bad inodes into kernel or e2fsprogs. For  
>>the resize inode, it is perhaps an incompatibility of this feature with  
>>48 bits blocks number, but for the bad inode ?
> 
> 
> There is a plan for how to handle online resizing for > 2^32 block
> filesystems, but it hasn't been implemented yet.  The basic support
> for it is there; that's what the META_BG feature is designed to
> support, so existing kernels will be able to deal with resized large
> filesystemes.  But the code to actually do the on-line resizing hasn't
> been implemented yet.
> 
> For the bad block inode, the solution is to make it be extent mapped
> inode.  This also hasn't been implemented yet, but this is a much
> simpler one to write.  The main reason why we haven't is that modern
> disks rarely have system-visible bad blocks; normally the hard drive
> has its own bad block remapping layer in hardware so we never see a
> bad block until the disk is failing so badly it needs to be replaced
> ASAP.
> 
> 						- Ted
> 
> 

Hi,

Thanks for the information.

Looking at ext4.h, I think the setting of extra time fields forgets to mask the epoch bits so the 
epoch part overwrites nsec part. The second change is only for coherency (2 -> EXT4_EPOCH_BITS):

--- fs/ext4/ext4.h.old  2009-09-12 09:45:42.161490080 +0200
+++ fs/ext4/ext4.h      2009-09-12 09:47:43.808996848 +0200
@@ -481,8 +481,8 @@
  static inline __le32 ext4_encode_extra_time(struct timespec *time)
  {
         return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
-                          time->tv_sec >> 32 : 0) |
-                          ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
+                          (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
+                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
  }

  static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
@@ -490,7 +490,7 @@
         if (sizeof(time->tv_sec) > 4)
                time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
                                << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
+       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
  }

  #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)                         \

Regards,

Damien
