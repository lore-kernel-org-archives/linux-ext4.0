From: Tao Ma <tm@tao.ma>
Subject: 38-rc1: umount+rmmod cause ext4 error.
Date: Wed, 19 Jan 2011 14:53:36 +0800
Message-ID: <4D368A70.5030103@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: npiggin@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:35649 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751980Ab1ASGxK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 01:53:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Nick and Ted,
	I ran some very basic test with 38-rc1 and my box run into error with 
the message like:

slab error in kmem_cache_destroy(): cache `ext4_inode_cache': Can't free 
all objects
Pid: 4395, comm: rmmod Not tainted 2.6.38-rc1 #1
Call Trace:
  [<ffffffff820d61dc>] ? kmem_cache_destroy+0x83/0xc7
  [<ffffffffa0574025>] ? destroy_inodecache+0x15/0x17 [ext4]
  [<ffffffffa05923d1>] ? ext4_exit_fs+0x109/0x143 [ext4]
  [<ffffffff8203d194>] ? put_online_cpus+0x56/0x58
  [<ffffffff8206735a>] ? module_refcount+0x85/0x9d
  [<ffffffff82067b22>] ? sys_delete_module+0x1b5/0x218
  [<ffffffff82074fc3>] ? audit_syscall_entry+0x187/0x1ba
  [<ffffffff82002a6b>] ? system_call_fastpath+0x16/0x1b
SLAB: cache with size 888 has lost its name
SLAB: cache with size 888 has lost its name
SLAB: cache with size 888 has lost its name
SLAB: cache with size 888 has lost its name

The reproduce process is simple:just rmmod ext4 immediately after umount 
an ext4 volume.

I have done some very simple investigation and it seems that with Nick's 
new ext4_i_callback, even after we do ext4_destroy_inode, it isn't 
freed. So after we destroy the ext_inode_cache, and when freeing the 
inode, it errors. Hope it helps. If you have any fixes, I can test it.

Regards,
Tao
