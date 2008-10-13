From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
Subject: Re: [PATCH 4/4] ext4: Fix file fragmentation during large file
	write.
Date: Mon, 13 Oct 2008 19:04:41 +0530
Message-ID: <20081013133441.GB9578@skywalker>
References: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31vyly2q8.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:26498 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbYJMNew (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 09:34:52 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1836852rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 06:34:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <m31vyly2q8.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 12:31:43AM +0400, Dmitri Monakhov wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > The range_cyclic writeback mode uses the address_space writeback_index
> > as the start index for writeback.  With delayed allocation we were
> > updating writeback_index wrongly resulting in highly fragmented file.
> > Number of extents reduced from 4000 to 27 for a 3GB file with the below
> > patch.
> Hi i've played with fragmentation patches with following result:
> I've had several crash and deadlocks
> for example objects wasn't freed on umount:
>  EXT4-fs: mballoc: 12800 blocks 13 reqs (6 success)
>  EXT4-fs: mballoc: 7 extents scanned, 12 goal hits, 1 2^N hits, 0 breaks, 0 lost
>  EXT4-fs: mballoc: 1 generated and it took 3024
>  EXT4-fs: mballoc: 7608 preallocated, 1536 discarded
>  slab error in kmem_cache_destroy(): cache `ext4_prealloc_space': Can't free all objects
>  Pid: 7703, comm: rmmod Not tainted 2.6.27-rc8 #3
> 
>  Call Trace:
>   [<ffffffff8028b011>] kmem_cache_destroy+0x7d/0xc0
>   [<ffffffffa03ca057>] exit_ext4_mballoc+0x10/0x1e [ext4dev]
>   [<ffffffffa03d35b3>] exit_ext4_fs+0x1f/0x2f [ext4dev]
>   [<ffffffff80250dff>] sys_delete_module+0x199/0x1f3
>   [<ffffffff8025d06e>] audit_syscall_entry+0x12d/0x160
>   [<ffffffff8020be0b>] system_call_fastpath+0x16/0x1b

Looking at the code i found this. I haven't test the change yet.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2f38754..acf6a32 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2569,7 +2569,7 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		list_del(&pa->pa_group_list);
 		count++;
-		kfree(pa);
+		kmem_cache_free(ext4_pspace_cachep, pa);
 	}
 	if (count)
 		mb_debug("mballoc: %u PAs left\n", count);
