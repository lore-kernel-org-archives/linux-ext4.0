From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Sat, 16 Mar 2013 10:32:19 +0800
Message-ID: <5143D9B3.3070405@gmail.com>
References: <20130315222818.GA16100@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39227 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3CPCc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2013 22:32:26 -0400
Received: by mail-pb0-f51.google.com with SMTP id un15so4523303pbc.24
        for <linux-ext4@vger.kernel.org>; Fri, 15 Mar 2013 19:32:26 -0700 (PDT)
In-Reply-To: <20130315222818.GA16100@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

Thanks for reporting it.

On 03/16/2013 06:28 AM, Eric Whitney wrote:
> I'm seeing Xfstest 285 consistently fail for the 1k test case using the
> latest dev branch while running on both x86 and ARM.  Subtest 08 is
> the problem. From the test output:
> 
> 08. Test file with unwritten extents, only have unwritten pages
> 08.01 SEEK_HOLE expected 0 or 4194304, got 11264.                 FAIL
> 08.02 SEEK_HOLE expected 1 or 4194304, got 11264.                 FAIL
> 08.03 SEEK_DATA expected 10240 or 10240, got 0.                   FAIL
> 08.04 SEEK_DATA expected 10240 or 10240, got 1.                   FAIL
> 
> From previous discussions, we expect 285 to fail in the ext3 (nodelalloc,
> no flex_bg, and no extents) test case, but in subtest 07.  It still does
> that.

Sorry, my latest patch doesn't finish yet.

> 
> In the dev branch, reverting 4f42f80a8f - "ext4: use s_extent_max_zeroout_kb
> value as number of kb" - results in success for 285 in the 1k test case.

Presumably this patch isn't root cause.  I suspect there are some bugs
in ext4_find_unwritten_pgoff().  I will check it.

Thanks,
						- Zheng
