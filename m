From: "Sachin P. Sant" <sachinp@in.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Mon, 23 Feb 2009 16:27:20 +0530
Message-ID: <49A28110.1000802@in.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <20090223021320.11019d64.akpm@linux-foundation.org> <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@ucw.cz>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45230 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZBWK5p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Feb 2009 05:57:45 -0500
In-Reply-To: <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Paul Mackerras wrote:
> It appears to have faulted on a load, implicating the source.  The
> address being referenced (0xc00000003f380000) doesn't look
> outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
> on, and what page size is selected?
Yes CONFIG_DEBUG_PAGEALLOC is enabled and the page size is 64K.

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_PPC_64K_PAGES=y

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

