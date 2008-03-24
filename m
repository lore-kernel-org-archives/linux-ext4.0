From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Mon, 24 Mar 2008 16:46:17 +0530
Message-ID: <20080324111617.GA14290@skywalker>
References: <200803141202.AA00330@TNESG9526.rs.jp.nec.com> <20080314125848.GE3542@webber.adilger.int> <47DE0F8D.2060106@rs.jp.nec.com> <20080317170846.GE3542@webber.adilger.int> <47E789E6.6000806@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:49324 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbYCXLQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 07:16:23 -0400
Content-Disposition: inline
In-Reply-To: <47E789E6.6000806@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
>>
>>   
> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
> in ext4 online defrag when kernel supports it.

Can you also look at the sparse warnings with the patches ?

-aneesh
