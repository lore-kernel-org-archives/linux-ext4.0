From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 4.1: 9a0e609e3fd ("dm: only run the queue on completion if
 ....") causes significant overhead in osq_lock on ext4/multipath
Date: Wed, 8 Jul 2015 09:57:58 -0400
Message-ID: <20150708135758.GA23521@redhat.com>
References: <559CE14E.7010209@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	"linux-kernel@vger.kernel.org >> Linux Kernel Mailing List"
	<linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559CE14E.7010209@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 08 2015 at  4:37am -0400,
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> not sure if this actually a mutex/s390/dm or ext4 problem, but it bisects down to a dm commit:
> 
> Mike,
> 
> commit 9a0e609e3fd8a95c96629b9fbde6b8c5b9a1456a ("dm: only run the queue on 
> completion if congested or no requests pending") causes a significant overhead
> if multiple processes access the same file on an ext4 file system on multipath,
> with direct io.
> 
> This actually appeared first with a kvm guest that has I/O on 500 virtio disks that
> are backed up by the same image file (I used this to test something else)
> 
> but something like the following (without kvm)
> 
> for ((d=1; d<500; d++)); do  dd if=fileonmultipathext4 of=/dev/null bs=4096 iflag=direct & done
> 
> keeps most CPUs on the osq_lock (optimistic spinning for mutex)
> 
> # Overhead  Command         Shared Object        Symbol                                     
> # ........  ..............  ...................  ...........................................
> #
>     73.91%  dd              [kernel.vmlinux]     [k] osq_lock                               
>      3.15%  dd              [kernel.vmlinux]     [k] mutex_spin_on_owner.isra.5             
>      3.03%  swapper         [kernel.vmlinux]     [k] osq_lock                               
>      1.08%  kdmwork-252:28  [kernel.vmlinux]     [k] osq_lock                               
>      0.91%  dd              [kernel.vmlinux]     [k] arch_spin_lock_wait_flags              
>      0.36%  dd              [kernel.vmlinux]     [k] kmem_cache_free                        
>      0.29%  dd              [kernel.vmlinux]     [k] account_system_time                    
>      0.25%  dd              [kernel.vmlinux]     [k] __blockdev_direct_IO                   
>      0.25%  dd              [kernel.vmlinux]     [k] _mix_pool_bytes                        
>      0.22%  dd              [kernel.vmlinux]     [k] __schedule                             
>      0.22%  dd              [kernel.vmlinux]     [k] pcpu_ec_call                           
>      0.21%  dd              [kernel.vmlinux]     [k] enqueue_entity                         
>      0.18%  dd              [kernel.vmlinux]     [k] vtime_account_irq_enter                
>      0.17%  dd              [dm_multipath]       [k] multipath_status                       
>      0.17%  dd              [kernel.vmlinux]     [k] try_to_wake_up                         
>      0.17%  dd              [kernel.vmlinux]     [k] update_cfs_shares                      
>      0.16%  dd              [kernel.vmlinux]     [k] blk_update_request  
> 
> With that patch reverted the system is much less contendent on osq_lock
> 
> # Overhead  Command         Shared Object      Symbol                                     
> # ........  ..............  .................  ...........................................
> #
>     30.22%  dd              [kernel.vmlinux]   [k] osq_lock                               
>      5.57%  dd              [kernel.vmlinux]   [k] mutex_spin_on_owner.isra.5             
>      5.48%  swapper         [kernel.vmlinux]   [k] osq_lock                               
>      1.61%  dd              [kernel.vmlinux]   [k] arch_spin_lock_wait_flags              
>      1.38%  dd              [kernel.vmlinux]   [k] arch_spin_lock_wait                    
>      1.17%  swapper         [kernel.vmlinux]   [k] mutex_spin_on_owner.isra.5             
>      0.67%  dd              [kernel.vmlinux]   [k] kmem_cache_free                        
>      0.63%  dd              [kernel.vmlinux]   [k] try_to_wake_up                         
>      0.63%  kdmwork-252:22  [kernel.vmlinux]   [k] osq_lock                               
>      0.57%  dd              [kernel.vmlinux]   [k] _mix_pool_bytes                        
>      0.57%  dd              [kernel.vmlinux]   [k] account_system_time                    
>      0.49%  dd              [kernel.vmlinux]   [k] pcpu_ec_call                           
>      0.48%  dd              [kernel.vmlinux]   [k] vtime_account_irq_enter                
>      0.44%  dd              [kernel.vmlinux]   [k] zfcp_fsf_reqid_check                   
>      0.42%  dd              [kernel.vmlinux]   [k] __blockdev_direct_IO                   
>      0.42%  dd              [kernel.vmlinux]   [k] enqueue_entity    
> 
> 
> Do you have any idea why this patch seems to affect mutex/sem hold times?

No.  Only thing I can think of is that it is creating additional back
pressure on the system and IO isn't proceeding as quickly as before.

This commit has shown itself to be a problem with extensive multipath IO
fault injection tests under load (excessive IO stalls).  So I intend to
revert it anyway -- this report helps cement the need for revert (I'll
cc stable@ too so it'll fix 4.1).

Mike
