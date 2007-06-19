From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4-block-reservation.patch
Date: Tue, 19 Jun 2007 10:05:23 -0500
Message-ID: <4677F0B3.4050805@redhat.com>
References: <4677B00A.3010600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: alex@clusterfs.com, linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXFSPLZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 11:11:25 -0400
In-Reply-To: <4677B00A.3010600@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> Hi,
> 
> In block reservation code while rebalancing the free blocks why are we not 
> looking at the reservation slots that have no free blocks left.  Rebalancing
> the free blocks equally across all the reservation slots will make sure
> we have less chances of failure later when we try to reserve blocks. 
> 
> 
> I understand that we consider the CPU slot on which reservation failed while
> rebalancing. But what is preventing considering other CPU slot that might have
> zero blocks left ?
> 
> 
> 
> 
> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
> +{
> +       int i, used_slots = 0;
> +       __u64 chunk;
> +
> +       /* let's know what slots have been used */
> +       for (i = 0; i < NR_CPUS; i++)

BTW... I think you really want:

  +       for_each_possible_cpu(i) {

in this and other similar places.

NR_CPUS is a config-time option that may be much more than your actual
count of runtime possible CPUs... on ia64 it's 512 by default, for
example.  That's a lot of pointlessness on a 2, 4 or 8 cpu box :)

I can whip up a proper patch for current code to send (again)...

-Eric


> +               if (rs[i].rs_reserved || i == smp_processor_id())
> +                       used_slots++;
> +
> +       /* chunk is a number of block every used
> +        * slot will get. make sure it isn't 0 */
> +       chunk = free + used_slots - 1;
> +       do_div(chunk, used_slots);
> +
> +       for (i = 0; i < NR_CPUS; i++) {
> +               if (free < chunk)
> +                       chunk = free;
> +               if (rs[i].rs_reserved || i == smp_processor_id()) {
> +                       rs[i].rs_reserved = chunk;
> +                       free -= chunk;
> +                       BUG_ON(free < 0);
> +               }
> +       }
> +       BUG_ON(free);
> +}
> 
> 
> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
