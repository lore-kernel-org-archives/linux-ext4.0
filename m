From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Thu, 24 Jan 2013 22:32:01 -0500
Message-ID: <20130125033201.GD28908@thunk.org>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45382 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab3AYDcH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 22:32:07 -0500
Content-Disposition: inline
In-Reply-To: <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 03:16:21PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After adding indirect punching hole feature, we need to enable it in fallocate.
> For this purpose, some sanity checks need to be adjusted.  Currently we need to
> check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.

I've folded these two patches into one since the first patch in this
series since there won't be any way to exercise the new code paths
until we enable this in fallocate(), and it doesn't really change
existing code paths.  If it did make huge changes in the normal code
path, it might be useful to keep the two commits separate, but that's
not the case here.

Anyway, they look good so I've checked them into my tree.  I'm
currently kicking off a test run to make sure there aren't any
problems except for the test 255 failure when testing w/o extents, but
I don't really anticipate any issues.

Thanks!!

							- Ted
