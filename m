From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Mon, 11 Dec 2006 17:28:15 -0800
Message-ID: <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
	 <20061206055822.GA6182@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:33890 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbWLLB2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Dec 2006 20:28:21 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBC1SIH0023011
	for <linux-ext4@vger.kernel.org>; Mon, 11 Dec 2006 20:28:18 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBC1SI0A527742
	for <linux-ext4@vger.kernel.org>; Mon, 11 Dec 2006 18:28:18 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBC1SIwT020316
	for <linux-ext4@vger.kernel.org>; Mon, 11 Dec 2006 18:28:18 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20061206055822.GA6182@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2006-12-06 at 11:28 +0530, Amit K. Arora wrote:

> @@ -1142,13 +1155,22 @@
>  	/* try to insert block into found extent and return */
>  	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
>  		ext_debug("append %d block to %d:%d (from %llu)\n",
> -				le16_to_cpu(newext->ee_len),
> +				ext4_ext_get_actual_len(newext),
>  				le32_to_cpu(ex->ee_block),
> -				le16_to_cpu(ex->ee_len), ext_pblock(ex));
> +				ext4_ext_get_actual_len(ex), ext_pblock(ex));
>  		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
>  			return err;
> -		ex->ee_len = cpu_to_le16(le16_to_cpu(ex->ee_len)
> -					 + le16_to_cpu(newext->ee_len));
> +
> +		/* ext4_can_extents_be_merged should have checked that either
> +		 * both extents are uninitialized, or both aren't. Thus we
> +		 * need to check any of them here.
> +		 */
> +		if (ext4_ext_is_uninitialized(ex))
> +			uninitialized = 1;
> +		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> +					 + ext4_ext_get_actual_len(newext));
> +		if(uninitialized)
> +			ext4_mark_uninitialized_ext(ex);
>  		eh = path[depth].p_hdr;
>  		nearex = ex;
>  		goto merge;

Hmm, I missed the point to re-mark an uninitialized extent here. If ex
is an uninitialized extent, the mark(the first bit the ee_len) shall
still there after the update, isn't?  We already make sure that two
large uninitialized extent can't get merged if the resulting length will
take the first bit, which used as the mark of uninitialized extent.
