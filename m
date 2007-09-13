From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Sparse endian issues with patches.
Date: Wed, 12 Sep 2007 18:32:58 -0600
Message-ID: <20070913003258.GR5377@schatzie.adilger.int>
References: <46E81867.1000606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: valerie.clement@bull.net, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48103 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXIMAcd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2007 20:32:33 -0400
Content-Disposition: inline
In-Reply-To: <46E81867.1000606@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 12, 2007  22:18 +0530, Aneesh Kumar K.V wrote:
> Attaching below patch that fix the sparse warning for ext4.

It would be good to also fix the "raw" access of split 48-bit and 64-bit
fields as I previously sent to the list.  A new typedef for these fields
(on disk) would ensure that they are not accessed directly and give
compiler warnings if new patches don't have the right macro usage.

> -				if (mnt_count != sbi->s_es->s_mnt_count) {
> +				if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {

That overflows 80 columns, as do several other lines.
> 

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
