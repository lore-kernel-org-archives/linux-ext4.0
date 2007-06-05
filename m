From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
 larger than 32-bit blocks (take 2).
Date: Tue, 5 Jun 2007 10:46:57 -0500
Message-ID: <20070605104657.13d60531@gara>
References: <20070601105234.4be40028@rx8>
	<20070601225441.GF5181@schatzie.adilger.int>
	<20070604113210.1a76934b@gara>
	<20070604175728.GT5181@schatzie.adilger.int>
	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
	<20070605064109.2cb6bad7@gara>
	<1181049283.18452.0.camel@kleikamp.austin.ibm.com>
	<4665649D.8010302@bull.net>
	<20070605084937.7622258a@gara>
	<46656D40.4050505@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, cmm@us.ibm.com,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57397 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764769AbXFEPrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 11:47:12 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l55FlCRY015400
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 11:47:12 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55FlCMV422032
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 11:47:12 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55FlB3h016349
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 11:47:11 -0400
In-Reply-To: <46656D40.4050505@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 05 Jun 2007 16:03:44 +0200
Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> Jose R. Santos wrote:
> > Hi Laurent,
> > 
> > In this particular case though, the value of s_blocks_count_hi should not be
> > uses on its own.  The correct way would be to use ext4_blocks_count() which
> > already does the endian conversion.  If you think the code could confuse
> > people as to how to access the data in s_blocks_count_hi, wouldn't hiding it
> > through the use of a macro make more sense than doing an unnecessary endian
> > conversion?
> > 
> 
> Yes, I think the code could confuse people, but I don't think defining "Yet
> Another Macro" is a good choice (IMHO).
> 
> I think we can resolve this (non-)issue by two ways:
> - using le32_to_cpu() (but I agree it does an unnecessary endian conversion on
> big-endian systems)

I just think that adding extra instructions for the sake of slightly
better code readability is wrong, especially when the value
s_blocks_count_hi should not be used on its own.

> - put a comment on the line (but are we allowed to put comments in kernel source
> code... ;-) )

One advantage of a macro here is that we would make the code more
explicit and should be able to eliminate the need for those 4 lines of
comments that this patch adds.

> Regards
> Laurent


-JRS
