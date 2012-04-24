From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix check for hidden quota files
Date: Tue, 24 Apr 2012 14:49:52 -0400
Message-ID: <20120424184952.GG18865@thunk.org>
References: <1334347864-12662-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: niu@whamcloud.com, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37036 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab2DXSt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 14:49:56 -0400
Content-Disposition: inline
In-Reply-To: <1334347864-12662-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 01:11:02PM -0700, Aditya Kali wrote:
> Currently e2fsck always incorrectly detects that quota inodes
> need to be hidden (even if they are already hidden) and
> modifies the superblock unnecessarily. This patch fixes the
> check for hidden quota files and avoids modifying the
> filesystem if quota inodes are already hidden.
> Also, zero-out the old quota inode so that next fsck scan
> doesn't complain.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, applied.

					- Ted
