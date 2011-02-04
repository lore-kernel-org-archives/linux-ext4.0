From: Tao Ma <tm@tao.ma>
Subject: Re: [BUG] v2.6.38-rc3+ BUG when calling destroy_inodecache at module
 unload
Date: Fri, 04 Feb 2011 16:36:59 +0800
Message-ID: <4D4BBAAB.4070500@tao.ma>
References: <4D4AF928.9030609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D4AF928.9030609@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/04/2011 02:51 AM, Boaz Harrosh wrote:
> Last good Kernel was 2.6.37
> I'm doing a "mount" then "unmount". I think root is the only created inode.
> rmmod is called immediately after "unmount" within a script
>
> if I only do unmount and manually call "modprobe --remove exofs" after a small while
> all is fine.
>
> I get:
> slab error in kmem_cache_destroy(): cache `exofs_inode_cache': Can't free all objects
> Call Trace:
> 77dfde08:  [<6007e9a6>] kmem_cache_destroy+0x82/0xca
> 77dfde38:  [<7c1fa3da>] exit_exofs+0x1a/0x1c [exofs]
> 77dfde48:  [<60054c10>] sys_delete_module+0x1b9/0x217
> 77dfdee8:  [<60014d60>] handle_syscall+0x58/0x70
> 77dfdf08:  [<60024163>] userspace+0x2dd/0x38a
> 77dfdfc8:  [<600126af>] fork_handler+0x62/0x69
>    
I also get a similar error when testing ext4 and a bug is opened there.

https://bugzilla.kernel.org/show_bug.cgi?id=27652

And I have done some simple investigation for ext4 and It looks as if now with the new *fs_i_callback doesn't free the inode to *fs_inode_cache immediately. So the old logic will destroy the inode cache before we free all the inode object.

Since there are more than one fs affected by this, we may need to find a way in the VFS.

Regards,
Tao

> The UML Kernel also crashes after this message, with:
>
> Modules linked in: nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cryptomgr aead crc32c crypto_hash crypto_algapi iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod binfmt_misc [last unloaded: libosd]
> Pid: 6, comm: rcu_kthread Not tainted 2.6.38-rc3+
> RIP: 0033:[<000000007c1fa0e7>]
> RSP: 000000007943be18  EFLAGS: 00010246
> RAX: 000000007943a000 RBX: 000000007937bb80 RCX: 0000000000000095
> RDX: 000000007937c8b8 RSI: 0000000077fb6c80 RDI: 000000007937bb80
> RBP: 000000007943be40 R08: 000000007943be10 R09: 000000007943a000
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000795123e0
> R13: 0000000000000001 R14: 0000000000000000 R15: 000000000000000a
> Call Trace:
> 602678f8:  [<600144ed>] segv+0x70/0x212
> 60267928:  [<6001cd9e>] ubd_intr+0x72/0xdf
> 60267988:  [<601b778e>] _raw_spin_unlock_irqrestore+0x18/0x1c
> 602679d8:  [<600146ee>] segv_handler+0x5f/0x65
> 60267a08:  [<60021488>] sig_handler_common+0x84/0x98
> 60267ab0:  [<60130926>] strncpy+0xf/0x27
> 60267b38:  [<600215ce>] sig_handler+0x30/0x3b
> 60267b58:  [<60021800>] handle_signal+0x6d/0xa3
> 60267ba8:  [<60023180>] hard_handler+0x10/0x14
>
> Kernel panic - not syncing: Segfault with no mm
> Call Trace:
> 602677f8:  [<601b52b1>] panic+0xea/0x1e6
> 60267818:  [<6007e299>] kmem_cache_free+0x54/0x5f
> 60267850:  [<6005342e>] __module_text_address+0xd/0x53
> 60267868:  [<6005347d>] is_module_text_address+0x9/0x11
> 60267878:  [<6004290c>] __kernel_text_address+0x65/0x6b
> 60267880:  [<60023180>] hard_handler+0x10/0x14
> 60267898:  [<6001345e>] show_trace+0x8e/0x95
> 602678c8:  [<60026c40>] show_regs+0x2b/0x2f
> 602678f8:  [<60014577>] segv+0xfa/0x212
> 60267928:  [<6001cd9e>] ubd_intr+0x72/0xdf
> 60267988:  [<601b778e>] _raw_spin_unlock_irqrestore+0x18/0x1c
> 602679d8:  [<600146ee>] segv_handler+0x5f/0x65
> 60267a08:  [<60021488>] sig_handler_common+0x84/0x98
> 60267ab0:  [<60130926>] strncpy+0xf/0x27
> 60267b38:  [<600215ce>] sig_handler+0x30/0x3b
> 60267b58:  [<60021800>] handle_signal+0x6d/0xa3
> 60267ba8:  [<60023180>] hard_handler+0x10/0x14
>
>
> Modules linked in: nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cryptomgr aead crc32c crypto_hash crypto_algapi iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod binfmt_misc [last unloaded: libosd]
> Pid: 6, comm: rcu_kthread Not tainted 2.6.38-rc3+
> RIP: 0033:[<0000003ea3832ad7>]
> RSP: 00007fff63338e38  EFLAGS: 00000202
> RAX: 0000000000000000 RBX: 0000000000000219 RCX: ffffffffffffffff
> RDX: 0000000000000000 RSI: 0000000000000013 RDI: 0000000000000219
> RBP: 00007fff63338e70 R08: 0000000000000000 R09: 00007fff63338e70
> R10: 00007fff63338be0 R11: 0000000000000202 R12: 0000000000000215
> R13: 00007fe54ee756a8 R14: 00007fff63339090 R15: 00007fff63339928
> Call Trace:
> 60267788:  [<6001485b>] panic_exit+0x2f/0x45
> 602677a8:  [<60048ad6>] notifier_call_chain+0x32/0x5e
> 602677e8:  [<60048b24>] atomic_notifier_call_chain+0x13/0x15
> 602677f8:  [<601b52cc>] panic+0x105/0x1e6
> 60267818:  [<6007e299>] kmem_cache_free+0x54/0x5f
> 60267850:  [<6005342e>] __module_text_address+0xd/0x53
> 60267868:  [<6005347d>] is_module_text_address+0x9/0x11
> 60267878:  [<6004290c>] __kernel_text_address+0x65/0x6b
> 60267880:  [<60023180>] hard_handler+0x10/0x14
> 60267898:  [<6001345e>] show_trace+0x8e/0x95
> 602678c8:  [<60026c40>] show_regs+0x2b/0x2f
> 602678f8:  [<60014577>] segv+0xfa/0x212
> 60267928:  [<6001cd9e>] ubd_intr+0x72/0xdf
> 60267988:  [<601b778e>] _raw_spin_unlock_irqrestore+0x18/0x1c
> 602679d8:  [<600146ee>] segv_handler+0x5f/0x65
> 60267a08:  [<60021488>] sig_handler_common+0x84/0x98
> 60267ab0:  [<60130926>] strncpy+0xf/0x27
> 60267b38:  [<600215ce>] sig_handler+0x30/0x3b
> 60267b58:  [<60021800>] handle_signal+0x6d/0xa3
> 60267ba8:  [<60023180>] hard_handler+0x10/0x14
>
> Thanks
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

