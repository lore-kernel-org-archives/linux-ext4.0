From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH]ext4: Enable mount ext4 with AGGRESSIVE_TEST
Date: Tue, 01 Sep 2009 10:35:40 +0900
Message-ID: <4A9C7A6C.5030708@rs.jp.nec.com>
References: <4A96118F.5040707@rs.jp.nec.com> <20090828144045.GH16732@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39041 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZIABf4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 21:35:56 -0400
In-Reply-To: <20090828144045.GH16732@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,
Theodore Tso wrote:
> On Thu, Aug 27, 2009 at 01:54:39PM +0900, Akira Fujita wrote:
>> When the AGGRESSIVE_TEST is enabled,
>> the maximum extent count of inode becomes '3' in ext4_ext_space_root(),
>> but __ext4_ext_check() which is called via ext4_fill_super()
>> checks eh_max is larger '4', therefore we always get -EIO and can not mount ext4.
>> The patch fix this issue.
> 
> This isn't really the right fix for the problem.
> 
> What's actually going on here is that the patch which added which
> sanity checks for extents, which added (among other functions)
> __ext4_ext_check() and ext4_ext_max_entries() doesn't quite work right
> in the presence of AGGRESSIVE_TEST.
> 
> The goal of AGGRESSIVE_TEST is to stress test the extent tree insert
> and deletion code by forcing the size of eh_max to be a smaller value
> than it otherwise would be.  It did this by dropping in limits to the
> values returned by ext4_ext_space_root(), ext4_ext_space_idx(),
> ext4_ext_space_block(), and ext4_ext_block_idx().  This worked all
> very well and coded when these functions were only used to initialize
> the eh_max field.
> 
> The problem is that the extent checking code also used these functions
> to check whether or not the extent tree was sane, and if
> AGGRESSIVE_TEST was enabled, it caused the journal to be considered
> invalid.
> 
> Your patch patches over the problem by changing ext4_ext_space_root to
> fix the one case where a problem arises, which patches over the
> problem for a freshly created filesystem, but it doesn't fix problems
> that will arise for a populated filesystem.  It also decreases the
> effectiveness of AGGRESSIVE_TEST.
> 

Thank you for careful explanation. :-)
I confirmed that the problem was fixed with your patch.

Tested-by: Akira Fujita <a-fujita@rs.jp.ne.com>

Regards,
Akira Fujita
