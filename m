From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext2fs: add multi-mount protection (INCOMPAT_MMP)
Date: Sat, 24 Sep 2011 14:49:54 -0400
Message-ID: <20110924184954.GF2779@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
 <1316821124-7461-3-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Johann Lombardi <johann@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48278 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab1IXSt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 14:49:56 -0400
Content-Disposition: inline
In-Reply-To: <1316821124-7461-3-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 05:38:43PM -0600, Andreas Dilger wrote:
> Multi-mount protection is feature that allows mke2fs, e2fsck, and
> others to detect if the filesystem is mounted on a remote node (on
> SAN disks) and avoid corrupting the filesystem.  For e2fsprogs this
> means that it checks the MMP block to see if the filesystem is in use,
> and marks the filesystem busy while e2fsck is running on the system.

Applied, thanks.

						- Ted
