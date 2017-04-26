From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] kvm: async_pf: fix rcu_irq_enter() with irqs enabled
Date: Wed, 26 Apr 2017 16:56:26 +0200
Message-ID: <20170426145626.6407-1-pbonzini@redhat.com>
Cc: rkrcmar@redhat.com, ross.zwisler@linux.intel.com,
        paulmck@linux.vnet.ibm.com, jack@suse.cz,
        linux-ext4@vger.kernel.org, tytso@mit.edu, josh@joshtriplett.org,
        stable@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

native_safe_halt enables interrupts, and you just shouldn't
call rcu_irq_enter() with interrupts enabled.  Reorder the
call with the following local_irq_disable() to respect the
invariant.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 14f65a5f938e..2a7835932b71 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -161,8 +161,8 @@ void kvm_async_pf_task_wait(u32 token)
 			 */
 			rcu_irq_exit();
 			native_safe_halt();
-			rcu_irq_enter();
 			local_irq_disable();
+			rcu_irq_enter();
 		}
 	}
 	if (!n.halted)
-- 
2.9.3
