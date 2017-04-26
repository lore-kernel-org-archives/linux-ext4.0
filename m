From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: kernel/rcu/tree.c:1031 rcu_irq_enter() invoked with irqs
 enabled!!!!
Date: Wed, 26 Apr 2017 16:29:55 +0200
Message-ID: <43412479-18a3-0c55-3d32-97c15ee5fe87@redhat.com>
References: <20170425201345.GB11773@linux.intel.com>
 <20170425202841.GF3956@linux.vnet.ibm.com>
 <20170426071636.GA21218@quack2.suse.cz> <20170426141858.GA26972@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33168 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3001015AbdDZOaI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Apr 2017 10:30:08 -0400
In-Reply-To: <20170426141858.GA26972@potion>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 26/04/2017 16:18, Radim Krčmář wrote:
>> OK, but looking at the stack trace, this has nothing to do with ext4. The
>> problem seems to be in KVM - relevant CCs added.
> The path begins with async_page_fault interrupt gate and the hardware
> should clear the interrupt flag before executing it.  I don't see a
> change that would break the assumption that interrupts are disabled ...

native_safe_halt enables interrupts.  I think this is it:

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

Paolo
