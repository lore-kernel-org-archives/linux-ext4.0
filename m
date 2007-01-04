From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 22:03:53 +0300
Message-ID: <m3irfmehra.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
	<20070103060601.GB5343@amitarora.in.ibm.com>
	<20070104085407.GC5345@amitarora.in.ibm.com>
	<m3zm8zdqjn.fsf@bzzz.home.net>
	<20070104112707.GB15920@amitarora.in.ibm.com>
	<m3r6ubdnuj.fsf@bzzz.home.net>
	<20070104172329.GA23612@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:63333 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932261AbXADTEI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 14:04:08 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070104172329.GA23612@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Thu\, 4 Jan 2007 22\:53\:29 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AKA> @@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
 AKA>  		 */
 AKA>  		if (ee_len > EXT_MAX_LEN)
 AKA>  			goto out2;
 AKA> +
 AKA> +		if (iblock < ee_block && iblock + max_blocks >= ee_block)
 AKA> +			allocated = ee_block - iblock;
 AKA> +
 AKA>  		/* if found extent covers block, simply return it */
 AKA>  	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
 AKA>  			newblock = iblock - ee_block + ee_start;

I thought existing code already does this:

	/* if found extent covers block, simply return it */
        if (iblock >= ee_block && iblock < ee_block + ee_len) {
		newblock = iblock - ee_block + ee_start;
		/* number of remaining blocks in the extent */
		allocated = ee_len - (iblock - ee_block);


thanks, Alex
