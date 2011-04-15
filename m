From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH]ext4: delete dead code
Date: Fri, 15 Apr 2011 13:16:10 +0900
Message-ID: <20110415041610.GD29512@mtj.dyndns.org>
References: <1302747032.3981.181.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:55086 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1DOEQP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2011 00:16:15 -0400
Received: by pxi2 with SMTP id 2so1326426pxi.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 21:16:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1302747032.3981.181.camel@sli10-conroe>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 10:10:32AM +0800, Shaohua Li wrote:
> percpu_counter_sum_positive never returns negative.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Ted, can you please pick this up?

Thanks.

-- 
tejun
