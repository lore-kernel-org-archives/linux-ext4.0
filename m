From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Tue, 15 Apr 2008 10:58:25 -0700
Message-ID: <1208282305.18386.67.camel@badari-desktop>
References: <20080415161430.GC28699@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43143 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYDOR6Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 13:58:24 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3FHwNLZ020087
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 13:58:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3FHwNgi222818
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 13:58:23 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3FHwM4J001761
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 13:58:23 -0400
In-Reply-To: <20080415161430.GC28699@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
> Hi,
> 
>   I've ported my patch inversing locking ordering of page_lock and
> transaction start to ext4 (on top of ext4 patch queue). Everything except
> delayed allocation is converted (the patch is below for interested
> readers).

I am curious on the following code:

ext4_ordered_writepage()

+ * Note that we don't need to start a transaction unless we're journaling
+ * data because we should have holes filled from ext4_page_mkwrite(). If
+ * we are journaling data, we cannot start transaction directly because
+ * transaction start ranks above page lock so we have to do some magic...

Currently you are starting a transaction when the page is locked. 
What do you plan to do here ?

Thanks,
Badari

