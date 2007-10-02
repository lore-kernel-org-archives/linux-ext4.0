From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2] ext3: Avoid rec_len overflow with 64KB block size
Date: Mon, 01 Oct 2007 18:05:40 -0700
Message-ID: <1191287140.11737.61.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
	 <1191285380.11737.60.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0710011801000.25158@schroedinger.engr.sgi.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, sho@tnes.nec.co.jp,
	Jan Kara <jack@suse.cz>, akmp@osdl.org
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43311 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXJBCQU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 22:16:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l922GKuM021996
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 22:16:20 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l922GJxf530852
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 22:16:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l922GJgW014547
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 22:16:19 -0400
In-Reply-To: <Pine.LNX.4.64.0710011801000.25158@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-10-01 at 18:01 -0700, Christoph Lameter wrote:
> [Note that these will also be useful for 64K IA64 configurations]
> 
> Acked-by: Christoph Lameter <clameter@sgi.com>
> -

Thanks!

> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
