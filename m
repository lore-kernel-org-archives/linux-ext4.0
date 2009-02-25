From: "Sachin P. Sant" <sachinp@in.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 16:38:22 +0530
Message-ID: <49A526A6.70509@in.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <20090223155116.GB5764@atrey.karlin.mff.cuni.cz> <49A395ED.5030607@in.ibm.com> <200902251752.56514.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linuxppc-dev@ozlabs.org, Jan Kara <jack@suse.cz>,
	Jan Kara <jack@ucw.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, benh@kernel.crashing.org
To: Mark Nelson <markn@au1.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:34418 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZBYLIa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 06:08:30 -0500
In-Reply-To: <200902251752.56514.markn@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark Nelson wrote:
> Hi Sanchin and Geert,
>
> Does the patch below fix the problems you're seeing? If it does I'll send
> a properly written up and formatted patch to linuxppc-dev (as well as
> another one to fix the same problem in copy_tofrom_user()).
>   
This patch fixes the issue at my side. I tried booting the system few times
and every single time it came up clean.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

