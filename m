From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: add extent-mapped journal regression test
Date: Sat, 11 Jun 2011 12:24:01 -0400
Message-ID: <20110611162401.GN11207@thunk.org>
References: <1307700412-11191-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39148 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1FKQYD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 12:24:03 -0400
Content-Disposition: inline
In-Reply-To: <1307700412-11191-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 04:06:52AM -0600, Andreas Dilger wrote:
> All of the regression tests in e2fsprogs still use a block-mapped
> journal (if any journal at all).  Add a simple regression test that
> tests extent-mapped journals for both mke2fs and e2fsck.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Added to the "next" branch, thanks.

					- Ted
