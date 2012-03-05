From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ignore ext3/ext2 only mount options
Date: Sun, 4 Mar 2012 21:41:04 -0500
Message-ID: <20120305024104.GC9087@thunk.org>
References: <1330177021-1189-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Thomas Baechler <thomas@archlinux.org>,
	Tobias Powalowski <tobias.powalowski@googlemail.com>,
	Dave Reisner <d@falconindy.com>
To: Tom Gundersen <teg@jklm.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36180 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2CEClG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 21:41:06 -0500
Content-Disposition: inline
In-Reply-To: <1330177021-1189-1-git-send-email-teg@jklm.no>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 25, 2012 at 02:37:01PM +0100, Tom Gundersen wrote:
> There is a regression when using the ext4 module to mount
> ext2 or ext3 filesystems: When mountoptions are used that are
> supported by ext2 or ext3, but not by ext4 the mount fails.
> 
> This patch changes the failure into a warning. The case when
> the ext4 module is not used for ext2/3 support is unchanged.
> 
> Report: https://bbs.archlinux.org/profile.php?id=33804
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Thomas Baechler <thomas@archlinux.org>
> Cc: Tobias Powalowski <tobias.powalowski@googlemail.com>
> Cc: Dave Reisner <d@falconindy.com>

Thanks.  This patch will be slightly modified due to some cleanup and
refactorization in ext4's mount option handling code that I've been
doing.

						- Ted
