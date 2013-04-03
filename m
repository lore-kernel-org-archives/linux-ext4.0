From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed, 3 Apr 2013 12:01:45 -0400
Message-ID: <20130403160145.GB14991@thunk.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
 <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
 <20130403123317.GD7741@thunk.org>
 <20130403130443.GA16014@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58966 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762477Ab3DCQBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 12:01:51 -0400
Content-Disposition: inline
In-Reply-To: <20130403130443.GA16014@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 09:04:43PM +0800, Zheng Liu wrote:
> I agree with you that we need to fix the big-endian bug in extent tree
> because it affects all people who use ext4 file system.  Meanwhile I
> think we need to fix the problem in punching hole and xattr because that
> has been there.  I have looked at Dmitry's patch, and it fixes some
> problems that is only in dev branch (e.g. migration).  I think this
> problem can be fixed in 3.10 later.  Meanwhile metadata_csum is still
> under ext4dev.  So I think it also can be fixed in next merge window.

I took a closer look at the issues that Dmitry found in the checksum
code (including in xattr.c), and it doesn't actually fix any runtime
bugs.  It's mainly issues picked up by static code analyzers, but it's
not anything which is high priority to backport to stable kernels.

It's also the case that the zero_ex code was fine in 3.8; the bug
where we failed to introduce byte swapping was introduced in 3.9-rc1.

So the good news is that from what I can tell, there is no actual bug
leading to fs/data corruption relating to big endian systems in the
3.8.x kernels, and hence, the fixup patch will not need a
cc:stable@vger.kernel.org tag.

So what I am currently thinking about doing is fixing the actual bugs
(zero_ex and indirect punch hole) for 3.9-rc6.  The cleanup changes is
important so we can more easily find bugs using static code analyzers,
but that can be saved for the next merge window.  Sounds like a plan?

						- Ted
