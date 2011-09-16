From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5 v2] e2fsprogs: create open() and stat() helpers
Date: Thu, 15 Sep 2011 23:50:20 -0400
Message-ID: <20110916035020.GS28181@thunk.org>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56171 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1IPDuX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:50:23 -0400
Content-Disposition: inline
In-Reply-To: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 06:42:56PM +0200, Lukas Czerner wrote:
> In many places we are using #ifdef HAVE_OPEN64 to determine if we can
> use open64() but that's ugly. This commit creates two new helpers
> ext2fs_open_file() for open() and ext2fs_stat() for stat(). Also we need
> new typedef ext2fs_struct_stat for struct stat.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the next branch, thanks.

					- Ted
