From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH] more sanity check in extents
Date: Thu, 18 Jan 2007 01:31:37 +0300
Message-ID: <m3zm8hl1yu.fsf@bzzz.home.net>
References: <m364bd85cm.fsf@bzzz.home.net>
	<20070117222331.GL5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe01.tochka.ru ([62.5.255.21]:54833 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755AbXAQWbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jan 2007 17:31:45 -0500
Received: from [85.141.215.250] (HELO gw.home.net)
  by fe01-umail.umail.ru (CommuniGate Pro SMTP 5.0.12)
  with ESMTPS id 89478435 for linux-ext4@vger.kernel.org; Thu, 18 Jan 2007 01:31:40 +0300
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20070117222331.GL5236@schatzie.adilger.int> (Andreas Dilger's
	message of "Wed\, 17 Jan 2007 15\:23\:31 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andreas Dilger (AD) writes:

 AD> On Jan 12, 2007  03:18 +0300, Alex Tomas wrote:
 >> +	/* after split, a leaf can get zero entries
 >> +	 * thus there is nothing to check */
 >> +	if (le16_to_cpu(path->p_hdr->eh_entries) == 0)
 >> +		return 0;
 >> +
 >> +	if (depth == 0)
 >> +		first = le32_to_cpu(EXT_FIRST_EXTENT(path->p_hdr)->ee_block);
 >> +	else
 >> +		first = le32_to_cpu(EXT_FIRST_INDEX(path->p_hdr)->ei_block);
 >> +	path--;
 >> +	key = le32_to_cpu(path->p_idx->ei_block);
 >> +	
 >> +	if (likely(first == key))
 >> +		return 0;

 AD> What happens if, say, a leaf is split and then the first part of the split
 AD> is removed?  This could only happen with punch() on a running filesystem,
 AD> but in e2fsck a corrupt extent will be removed from the leaf without
 AD> updating the parent index's range.

hmm. e2fsck must update. there are other places in extents where
first extent in a block is supposed to match key in index.
ldiskfs_ext_next_allocated_block(), for example.

thanks, Alex
