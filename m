From: Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH 9/9] libext2fs: sort keys for xattr blocks
Date: Sun, 14 Feb 2016 10:37:06 +0000
Message-ID: <1455446226.16142.387.camel@linuxfoundation.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
	 <20160213223824.25381.8002.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 5751f4a1.skybroadband.com ([87.81.244.161]:62803 "EHLO
	dan.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbcBNKhU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Feb 2016 05:37:20 -0500
In-Reply-To: <20160213223824.25381.8002.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2016-02-13 at 14:38 -0800, Darrick J. Wong wrote:
> Richard Purdie reports that libext2fs doesn't sort attribute keys in
> the xattr block correctly, causing the kernel to return -ENODATA when
> querying attributes that should be there.  Therefore, sort attributes
> so that whatever ends up in the xattr block is sorted according to
> what the kernel expects.
> 
> Cc: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/ext_attr.c        |   24 +++++++++++-
>  tests/d_xattr_sorting/expect |   29 ++++++++++++++
>  tests/d_xattr_sorting/name   |    1 
>  tests/d_xattr_sorting/script |   86
> ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 139 insertions(+), 1 deletion(-)
>  create mode 100644 tests/d_xattr_sorting/expect
>  create mode 100644 tests/d_xattr_sorting/name
>  create mode 100644 tests/d_xattr_sorting/script

I had some test scripts I'd used to debug this. I applied this patch
and those tests passed, thanks!

Tested-by: Richard Purdie <richard.purdie@linuxfoundation.org>

I'll update the version of this we're using in OpenEmbedded and the
Yocto Project to your patch.

Cheers,

Richard

