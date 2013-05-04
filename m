From: Ji Wu <wu_ji2012@163.com>
Subject: Two questions regarding ext4_fallocate()
Date: Sat, 04 May 2013 23:31:42 +0800
Message-ID: <518529DE.4080302@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [220.181.12.14] ([220.181.12.14]:39078 "EHLO m12-14.163.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760442Ab3EDPcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 11:32:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
    I have two questions regarding ext4_fallocate(),

    (1) The first is the FALLOC_FL_PUNCH_HOLE support, I am wondering
what is the usage for it? The only use case comes to my mind is while 
ext4 being
used for virtual machine image file storage. When VMM is aware of the 
file deleting
operation in guest os, it can invoke host file system's fallocate() on 
the virtual machine
image file to punch a hole to free host storage, so that save host 
space. But how can VMM being
aware of guest file deleting? Simulate a virtual SSD-like block device 
to guest os,
then capture the TRIM instruction issued by guest file system? That 
seems too tricky.
So basically, where and how to benefit from hole punching?

    (2) At the beginning of the function ext4_ext_punch_hole(), the 
codes are as follows,

         /* write out all dirty pages to avoid race condition */
         filemap_write_and_wait_range(mapping, offset, offset+length-1);
         mutex_lock(&inode->i_mutex);
         truncate_page_cache_range();

     Why does it need synchronously write back the dirty pages fit into 
the hole,
     the data on the disk responding to those pages are to be deleted, 
why not directly
     release those pages, no matter they are dirty or not. And 
furthermore, this is done
     before the inode lock is held, so it seems it may happen that after 
the pages are written
     back, and before the lock is held, those pages are dirtied again.
     So basically, why does it need call filemap_write_and_wait_range() 
before releasing those pages?

Explanations are appreciated.

Cheers,
Ji Wu

