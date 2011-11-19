From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Date: Sat, 19 Nov 2011 15:29:34 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1111191524200.5986@chino.kir.corp.google.com>
References: <1321742924-3189-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1KSX3h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 18:29:37 -0500
Received: by iage36 with SMTP id e36so5381891iag.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 15:29:36 -0800 (PST)
In-Reply-To: <1321742924-3189-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 20 Nov 2011, Namjae Jeon wrote:

> If group info caches set to SLAB_MEM_SPREAD flags, the allocation is 
> spread evenly over all the memory nodes when using cpuset.

Incorrect, it also requires the cpuset to enable cpuset.memory_spread_slab 
which is not the default.

> It is useful because group info caches are long lived.
> 

As mentioned earlier, you should be able to get performance data as a 
result of this change by using any kernel, enabling CONFIG_CPUSETS and 
CONFIG_SLAB, mounting cpusets at runtime, enabling 
cpuset.memory_spread_slab, creating a mempolicy of MPOL_INTERLEAVE over 
all nodes, and then running your comparison benchmark.  This requires no 
modification of the kernel and will determine what performance benefit 
there is by doing this on your own hardware that you're interested in.

If there is convincing data that suggests it's helpful on your hardware, 
then it would make a good case to merge your patch so users don't need to 
set their own mempolicies that do this.  They'll just need to mount 
cpusets and enable cpuset.memory_spread_slab.

Absent that, there's no purpose in adding this flag.  If you're doing it 
just because it's done in other filesystems, mention that in the changelog 
so it can be judged on that criteria rather than pretending like the NUMA 
affinity actually means anything to your environment.
