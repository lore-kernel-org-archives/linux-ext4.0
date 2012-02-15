From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: recognize mke4fs program name
Date: Wed, 15 Feb 2012 14:20:58 -0500
Message-ID: <20120215192058.GH11382@thunk.org>
References: <4F32E173.2050103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46168 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab2BOTVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 14:21:03 -0500
Content-Disposition: inline
In-Reply-To: <4F32E173.2050103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 08, 2012 at 02:56:19PM -0600, Eric Sandeen wrote:
> We shipped "mke4fs" alongside mke2fs in RHEL5, so that ext4-capable
> utilities could be installed without disturbing the venerable e2fsprogs-1.39
> shipped in RHEL5 from the beginning.  But it surprised some users that
> "mke4fs" created ext2 filesystems by default rather than ext4.
> While it was my intent to have the renamed binaries behave exactly
> like the stock ones, it seems that there is some precedence for
> handling "mkeNfs" in the code, so seems reasonable to add 
> mke4fs -> ext4 as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
