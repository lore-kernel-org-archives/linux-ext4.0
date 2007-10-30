From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: [RFC/PATCH] ext4: Clear the reservation window correctly with
 delayed allocation.
Date: Tue, 30 Oct 2007 14:24:42 +0300
Message-ID: <4727147A.1060109@gmail.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com>
 <4725BEDC.5090902@linux.vnet.ibm.com> <47270F0B.8010708@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:41367 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXJ3LYz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2007 07:24:55 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id l9UBOo0S014425
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 11:24:50 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQQ00I012D95E00@fe-emea-10.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Tue,
 30 Oct 2007 11:24:50 +0000 (GMT)
In-reply-to: <47270F0B.8010708@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

what if writepages went through 100 pages only and another 100 are left because
negative wbc->nr_to_write?

thanks, Alex

Aneesh Kumar K.V wrote:
> @@ -1410,7 +1410,14 @@ out:
> static int ext4_da_writepages(struct address_space *mapping,
>                   struct writeback_control *wbc)
> {
> -    return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> +    int retval;
> +    retval = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> +    if (!retval) {
> +        /* if writepages is successfull discard the reservation */
> +        ext4_discard_reservation(mapping->host);
> +    }
> +
> +    return retval;
> }
> 
> static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
> 
> 
> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
