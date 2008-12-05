From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] percpu_counter: FBC_BATCH might be too big
Date: Fri, 05 Dec 2008 12:32:02 -0800 (PST)
Message-ID: <20081205.123202.98853955.davem@davemloft.net>
References: <4939513C.3090101@cosmosbay.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, travis@sgi.com,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: dada1@cosmosbay.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51325
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYLEUcC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Dec 2008 15:32:02 -0500
In-Reply-To: <4939513C.3090101@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 05 Dec 2008 17:05:16 +0100

> For NR_CPUS >= 16 values, FBC_BATCH is 2*NR_CPUS
> 
> Considering more and more distros are using high NR_CPUS values,
> it makes sense to use a more sensible value for FBC_BATCH.
> 
> A sensible value is 2*num_online_cpus(), with a minimum value of 32
> (This minimum value helps branch prediction in __percpu_counter_add())
> 
> We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamically.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

The downside is now we must load this value in these common
routines.  But I think the gain outweights the loss so:

Acked-by: David S. Miller <davem@davemloft.net>
