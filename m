From: Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH] kvm: async_pf: fix rcu_irq_enter() with irqs enabled
Date: Mon, 5 Jun 2017 12:21:00 +0800
Message-ID: <CANRm+CxZZxQkZwNPKPwTyrh_XdoLYeMqexjdkZdhx7pXOMf=+Q@mail.gmail.com>
References: <20170426145626.6407-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        ross.zwisler@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, jack@suse.cz,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        Josh Triplett <josh@joshtriplett.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170426145626.6407-1-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2017-04-26 22:56 GMT+08:00 Paolo Bonzini <pbonzini@redhat.com>:
> native_safe_halt enables interrupts, and you just shouldn't
> call rcu_irq_enter() with interrupts enabled.  Reorder the
> call with the following local_irq_disable() to respect the
> invariant.
>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I'm afraid we miss this commit. This commit can fix the below warning
against my testing, so feel free to add:

Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>


 =============================
 WARNING: suspicious RCU usage
 4.12.0-rc3+ #23 Tainted: G           O
 -----------------------------
 kernel/rcu/tree.c:1040 rcu_irq_enter() invoked with irqs enabled!!!!

 other info that might help us debug this:


 rcu_scheduler_active = 2, debug_locks = 0
 1 lock held by update-notifier/1661:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff94061bfc>]
__do_page_fault+0x13c/0x5a0

 stack backtrace:
 CPU: 3 PID: 1661 Comm: update-notifier Tainted: G           O
4.12.0-rc3+ #23
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
 Call Trace:
  dump_stack+0x99/0xce
  lockdep_rcu_suspicious+0xd7/0x110
  rcu_irq_enter+0xa0/0xb0
  kvm_async_pf_task_wait+0x210/0x260
  do_async_page_fault+0x77/0xb0
  ? do_async_page_fault+0x77/0xb0
  async_page_fault+0x28/0x30
 RIP: 0010:copy_page+0x7/0x10
 RSP: 0000:ffffaa3d834d7da0 EFLAGS: 00010286
 RAX: 0000000000000002 RBX: 0000000000eb3f00 RCX: 0000000000000200
 RDX: 0000000000000000 RSI: ffff93f6bf36f000 RDI: ffff93f33acfc000
 RBP: ffffaa3d834d7e58 R08: ffff93f6db998cb0 R09: 0000000000000000
 R10: 00000000fef20a58 R11: b143443d00000000 R12: 0000000000000200
 R13: ffffaa3d834d7dc0 R14: ffff93f6bf36f000 R15: ffff93f6db998000
  ? __handle_mm_fault+0xed1/0x11f0
  handle_mm_fault+0x18a/0x350
  __do_page_fault+0x29f/0x5a0
  trace_do_page_fault+0x6b/0x2f0
  do_async_page_fault+0x53/0xb0
  async_page_fault+0x28/0x30
 RIP: 0033:0x7f7d448b2a84
 RSP: 002b:00007ffc129bead8 EFLAGS: 00010202
 RAX: 00007f7d42a063c0 RBX: 0000000000000003 RCX: 00007f7d42a06400
 RDX: 0000000000000080 RSI: 0000000000000000 RDI: 00007f7d42a063c0
 RBP: 00007ffc129bed80 R08: 00007f7d42a06440 R09: 000000000000b000
 R10: 00007ffc129beb10 R11: 00007f7d42a06440 R12: 00007f7d44a9f500
 R13: 00007ffc129bee68 R14: 0000000000000002 R15: 000000000000fd01

> ---
>  arch/x86/kernel/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 14f65a5f938e..2a7835932b71 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -161,8 +161,8 @@ void kvm_async_pf_task_wait(u32 token)
>                          */
>                         rcu_irq_exit();
>                         native_safe_halt();
> -                       rcu_irq_enter();
>                         local_irq_disable();
> +                       rcu_irq_enter();
>                 }
>         }
>         if (!n.halted)
> --
> 2.9.3
>
