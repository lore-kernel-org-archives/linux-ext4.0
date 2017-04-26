From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] kvm: async_pf: fix rcu_irq_enter() with irqs enabled
Date: Wed, 26 Apr 2017 08:14:51 -0700
Message-ID: <20170426151451.GS3956@linux.vnet.ibm.com>
References: <20170426145626.6407-1-pbonzini@redhat.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rkrcmar@redhat.com, ross.zwisler@linux.intel.com, jack@suse.cz,
        linux-ext4@vger.kernel.org, tytso@mit.edu, josh@joshtriplett.org,
        stable@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1043309AbdDZPQS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Apr 2017 11:16:18 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3QF99g2027214
        for <linux-ext4@vger.kernel.org>; Wed, 26 Apr 2017 11:16:18 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2a2wj31wbk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 26 Apr 2017 11:16:17 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Wed, 26 Apr 2017 11:16:16 -0400
Content-Disposition: inline
In-Reply-To: <20170426145626.6407-1-pbonzini@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 26, 2017 at 04:56:26PM +0200, Paolo Bonzini wrote:
> native_safe_halt enables interrupts, and you just shouldn't
> call rcu_irq_enter() with interrupts enabled.  Reorder the
> call with the following local_irq_disable() to respect the
> invariant.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> -- 
> 2.9.3
> 
