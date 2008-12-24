From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Problems with the max value for create directory
Date: Wed, 24 Dec 2008 18:54:22 -0500
Message-ID: <20081224235422.GB23723@mit.edu>
References: <495054DE.9030405@cn.fujitsu.com> <495062D1.6010805@jp.fujitsu.com> <20081223201247.GU23723@mit.edu> <49518DFD.8090507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63817 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYLXXyc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Dec 2008 18:54:32 -0500
Content-Disposition: inline
In-Reply-To: <49518DFD.8090507@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 24, 2008 at 09:18:53AM +0800, Zhang Xiliang wrote:
>
> Thanks for explanation.
>
> I see the limit of ext4 subdirectory. The test program originally tests it.
> But I fail and find the limit of the htree.

But if that was your goal, why did you use the largest possible
filename length for the subdirectories?  And why did you use a 1k
block filesystem?  Both of these are totally unnecessary if the goal
is to test the limit of the number of ext4 subdirectories, and are
*ideal* if you are trying to detect the htree limit.

> I think it may be annoying. Somebody may be puzzled for the two limits.
> The limit of the htree should be greater than the limit of ext4 subdirectory.

Well, are you annoyed enough to help to try to solve the problem?  In
actual practice very few people have run across the htree limit as far
as I know.  

							- Ted
