From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Sparse endian issues with patches.
Date: Wed, 12 Sep 2007 17:36:31 -0700
Message-ID: <1189643792.11977.2.camel@localhost.localdomain>
References: <46E81867.1000606@linux.vnet.ibm.com>
	 <20070913003258.GR5377@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	valerie.clement@bull.net, linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35251 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXIMAgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2007 20:36:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8D0aXm5003482
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:36:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8D0aXhQ655300
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:36:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8D0aWJR026618
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:36:33 -0400
In-Reply-To: <20070913003258.GR5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-09-12 at 18:32 -0600, Andreas Dilger wrote:
> On Sep 12, 2007  22:18 +0530, Aneesh Kumar K.V wrote:
> > Attaching below patch that fix the sparse warning for ext4.
> 
> It would be good to also fix the "raw" access of split 48-bit and 64-bit
> fields as I previously sent to the list.  A new typedef for these fields
> (on disk) would ensure that they are not accessed directly and give
> compiler warnings if new patches don't have the right macro usage.
> 
> > -				if (mnt_count != sbi->s_es->s_mnt_count) {
> > +				if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
> 
> That overflows 80 columns, as do several other lines.
> > 
> 

checkpatch.pl should catched this... The version in ext4-patch queue
should be clean now.


> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
