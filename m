From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: kernel/rcu/tree.c:1031 rcu_irq_enter() invoked with irqs
 enabled!!!!
Date: Wed, 26 Apr 2017 16:39:20 +0200
Message-ID: <20170426143920.GA27155@potion>
References: <20170425201345.GB11773@linux.intel.com>
 <20170425202841.GF3956@linux.vnet.ibm.com>
 <20170426071636.GA21218@quack2.suse.cz>
 <20170426141858.GA26972@potion>
 <43412479-18a3-0c55-3d32-97c15ee5fe87@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161427AbdDZOjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Apr 2017 10:39:44 -0400
Content-Disposition: inline
In-Reply-To: <43412479-18a3-0c55-3d32-97c15ee5fe87@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2017-04-26 16:29+0200, Paolo Bonzini:
> On 26/04/2017 16:18, Radim Krčmář wrote:
>>> OK, but looking at the stack trace, this has nothing to do with ext4. The
>>> problem seems to be in KVM - relevant CCs added.
>> The path begins with async_page_fault interrupt gate and the hardware
>> should clear the interrupt flag before executing it.  I don't see a
>> change that would break the assumption that interrupts are disabled ...
> 
> native_safe_halt enables interrupts.  I think this is it:
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 14f65a5f938e..2a7835932b71 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -161,8 +161,8 @@ void kvm_async_pf_task_wait(u32 token)
>  			 */
>  			rcu_irq_exit();
>  			native_safe_halt();
> -			rcu_irq_enter();
>  			local_irq_disable();
> +			rcu_irq_enter();
>  		}
>  	}
>  	if (!n.halted)

We called rcu_irq_enter() there twice, *facepalm*.
Yes, that patch should fix it.
