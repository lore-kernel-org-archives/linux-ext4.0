From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
 larger than 32-bit blocks (take 2).
Date: Tue, 5 Jun 2007 08:49:37 -0500
Message-ID: <20070605084937.7622258a@gara>
References: <20070601105234.4be40028@rx8>
	<20070601225441.GF5181@schatzie.adilger.int>
	<20070604113210.1a76934b@gara>
	<20070604175728.GT5181@schatzie.adilger.int>
	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
	<20070605064109.2cb6bad7@gara>
	<1181049283.18452.0.camel@kleikamp.austin.ibm.com>
	<4665649D.8010302@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, cmm@us.ibm.com,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40293 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761586AbXFENt6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 09:49:58 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l55Dnu5X018511
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 09:49:56 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55Dnuc4137288
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 07:49:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55DntDE025705
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 07:49:56 -0600
In-Reply-To: <4665649D.8010302@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 05 Jun 2007 15:26:53 +0200
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Dave Kleikamp wrote:
> > Jose is right.  The endian conversion is unnecessary.
> > 
> > Shaggy
> 
> But by using le32_to_cpu(es->s_blocks_count_hi) you explicitly mark the variable
> as a little-endian.
> So if someone reads the code, he knows this is a little-endian value and this
> allows to avoid errors if later variable must be tested for other value than 0.
> 
> For instance, you have :
> 
> if(es->s_blocks_count_hi)
> 
> and later the value should be compared to 10, how do you know easily you should use:
> 
> if (le32_to_cpu(es->s_blocks_count_hi) == 10)
> 
> instead of
> 
> if(es->s_blocks_count_hi == 10)
> 
> I think writing like Mingming asks should allow to avoid errors later.
> 
> (and code becomes really self-explicit...)
> 
> Regards,
> Laurent

Hi Laurent,

In this particular case though, the value of s_blocks_count_hi should not be uses on its own.  The correct way would be to use ext4_blocks_count() which already does the endian conversion.  If you think the code could confuse people as to how to access the data in s_blocks_count_hi, wouldn't hiding it through the use of a macro make more sense than doing an unnecessary endian conversion?

-JRS
