From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3 v5] XFS TESTS: Add ENOSPC Hole Punch Test
Date: Fri, 17 Jun 2011 13:20:15 -0700
Message-ID: <4DFBB6FF.8080208@linux.vnet.ibm.com>
References: <4DED6405.7020104@vnet.ibm.com> <20110617120838.GA20714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@vnet.ibm.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36103 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1FQUUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 16:20:46 -0400
In-Reply-To: <20110617120838.GA20714@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/17/2011 05:08 AM, Christoph Hellwig wrote:
> This one fails for me because my test system doesn't have sudo
> installed.  I can't see any reason why a simple su wouldn't be enough.
>
> We already have a helper to make su usable on both IRIX and Linux in
> test 123, and it might be a good idea to add this to the common routines
> and use it.
>
> I'd also suggest to split this test off 252 into a new test case, as
> unlike the other tests it actually requires a scratch devices, and in
> general is pretty different from the simple xfs_io exercises in 252.
>
> I'd also move the newly added helpers directly into the new testcase
> as they really aren't common.
>

Hi Christoph,

Thanks for the review, I will make those adjustments then and submit 
them in a separate patch set since it sounds like 1/3 and 2/3 are moving 
forward.  Thanks again!  :)

Allison Henderson
