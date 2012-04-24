From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: quiet harmless inode/blocks errors
Date: Tue, 24 Apr 2012 16:23:06 -0400
Message-ID: <20120424202305.GJ18865@thunk.org>
References: <1334267637-25977-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49440 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab2DXUXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 16:23:09 -0400
Content-Disposition: inline
In-Reply-To: <1334267637-25977-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 12, 2012 at 03:53:57PM -0600, Andreas Dilger wrote:
> Don't consider only an error in the superblock summary as incorrect.
> The kernel does not update this field except at unmount time, so
> don't print errors during a "-n" run if there is nothing else wrong.
> Any other unfixed errors will themselves mark the filesystem invalid.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

					- Ted
