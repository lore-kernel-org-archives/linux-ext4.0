From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 10:23:13 -0800
Message-ID: <459D4611.3090707@us.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com>	<m364bpn5ku.fsf@bzzz.home.net> <20070102094727.GA5932@amitarora.in.ibm.com>	<m3irfobg29.fsf@bzzz.home.net> <459BF0C5.2060302@us.ibm.com> <m3hcv7f6r2.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36373 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbXADSXV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 13:23:21 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04INIi6025140
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 13:23:18 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04INIQO486850
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 11:23:18 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04INHpL023597
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 11:23:18 -0700
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3hcv7f6r2.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>>Mingming Cao (MC) writes:
> 
> 
>  MC> But the bug Amit pointed here is unrelated to the code convert
>  MC> uninitialized blocks to initialized ones. Rather, it's related to do
>  MC> multiple block allocation across on a window with parts already have
>  MC> blocks allocated. Without the check, the current code just simply
>  MC> allocate the requested extent and insert it into the tree which might
>  MC> overlap with existing extent.
> 
> correct. thanks for catching. in delayed allocation patch
> get_blocks() isn't used and ext4_ext_walk_space() works
> right in this case.
> 

Yep, I realized that yesterday. That explains we never see this overlap 
problem when we testing extent+delalloc+mballoc last year.

  ext4_ext_walk_space did almost all the overlap check.  I think we 
could reuse that code.

Mingming
> thanks, Alex
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
