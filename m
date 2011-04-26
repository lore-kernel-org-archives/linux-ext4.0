From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Tue, 26 Apr 2011 12:08:52 -0700
Message-ID: <4DB71844.5030103@linux.vnet.ibm.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38320 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1DZTI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2011 15:08:57 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3QIhCBs010667
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 14:43:12 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3QJ8sak684138
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 15:08:54 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3QJ8s3w001506
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 15:08:54 -0400
In-Reply-To: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
> v0->v1:
>     fix a bug in ext4_ext_convert_to_initialized() reported by
>     Allison<achender@linux.vnet.ibm.com>.
>
>     optimize ext4_ext_convert_to_initialized().
>
> -- factor common code
>     These patches factor common code from ext4_ext_convert_to_initialized() and
>     ext4_split_unwritten_extents() so that extent-move-on-write in snapshot and
>     punch hole can be built on the common code.
>
> -- optimization
>     the 4th and the 5th patch optimize ext4_ext_convert_to_initialized() by
>     zeroing out in memory.
>
>
> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and left.
> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi there,

Just an update on your patch set.  Im am working on getting the punch 
hole patch to work with this new set, but I'm am having trouble getting 
it through the stress test.  It gets up to around 48265 file operations, 
and then hangs. So I am currently trying to narrow down the problem.  It 
looks like it does it with or with out the extra punch hole patches, but 
you may need to enable fallocate in the fsx Makefile to recreate the 
problem.  I will keep you posted if I find any more clues.

Allison Henderson
