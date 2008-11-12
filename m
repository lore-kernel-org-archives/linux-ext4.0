From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 0/3][RFC] release block-device-mapping buffer_heads which
 have the filesystem private data for avoiding oom-killer
Date: Wed, 12 Nov 2008 16:49:32 +0900
Message-ID: <20081112164932.a4220c21.toshi.okajima@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
	<20081020160249.ff41f762.akpm@linux-foundation.org>
	<20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
	<20081027142657.2120aa3f.akpm@linux-foundation.org>
	<49067D03.6080609@jp.fujitsu.com>
	<20081105131140.7689f048.toshi.okajima@jp.fujitsu.com>
	<20081105135349.GA22998@mit.edu>
	<4913B35A.8080203@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk,
	sct@redhat.com, adilger@sun.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4913B35A.8080203@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

I found it possible that even if a lot of pages can be logically released, 
they cannot be released by try_to_release_page, and then they keep remaining.

This case enables an oom-killer to happen easily.

Details of the root cause and my patch which fixes it are shown below.
---
The direct data blocks can be released by the member function, releasepage()
of their mapping of the filesystem i-node.
(If an ext3 has the i-node, ext3_releasepage() is used as releasepage().) 

On the other hand, the indirect data blocks (ext3) are attempted to be released
by try_to_free_buffers(). (And other metadata are also done by it.)
Because a block device has its mapping, and doesn't have own member function 
to release a page. 

But try_to_free_buffers() is a generic function which releases buffer_heads
(and a page), and no buffer_head can be released if a buffer_head has private 
data (like journal_head) because the buffer_head's reference counter is bigger
than 0. Therefore, try_to_free_buffers() cannot release a buffer_head even if
it is possible to release its private data.

As a result, oom-killer may happen when a system memory is exhausted even if 
it is possible to release a lot of private data and their pages, because 
try_to_free_buffers() doesn't release such pages.

In order to solve this situation, we add a member function into a block device
 to release private data and then the page. 
This member function is:
- registered at a filesystem initialization time (get_sb_bdev()) 
- unregistered at a filesystem unmount time (kill_block_super())

This member function's pointer is located in a bdev_inode structure.
Besides, a client which registers it is also added into this structure. 
A client for a filesystem is its superblock. 

If we use an ext3, this additional member function can do equal processing to
ext3_releasepage() by using the superblock. And a block device's releasepage() 
is necessary to call this additional member function. Therefore we need a 
member function, 'releasepage' of the mapping of a block device.

Changing like them becomes possible to release private data and then the page
via try_to_release_page().
Therefore it becomes difficult for oom-killer to happen than before.
Because this patch enables journal_heads to be released more efficiently
in case of ext3.

I will post patches to solve it (ext3/ext4 version):
(1) [patch 1/3] vfs: release block-device-mapping buffer_heads which have the 
               filesystem private data for avoiding oom-killer
(2) [patch 2/3] ext3: release block-device-mapping buffer_heads which have the
               filesystem private data for avoiding oom-killer
(3) [patch 3/3] ext4: release block-device-mapping buffer_heads which have the
               filesystem private data for avoiding oom-killer

[Additional information]
I have confirmed that JBD on 2.6.28-rc4 to which my patch was applied could keep 
running for long time without oom-killer under the heavy loads.
(Of course, JBD without the patch cannot keep running for long time
under the same situation.)
* This patch needs Ted's fix which was posted at "Wed, 5 Nov 2008 09:05:07 -0500"
* as "[PATCH] jbd: don't give up looking for space so easily in 
* __log_wait_for_space". 
* Because "no transactions" error happens easily by releasing journal_heads 
* efficiently with my patch.
* But linux-2.6.28-rc4 includes his patch. Therefore I don't care about this.

Any comments are welcome.

Best Regards,
Toshiyuki Okajima
