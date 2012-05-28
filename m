From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix strtoblk for 64bit block numbers
Date: Sun, 27 May 2012 22:12:28 -0400
Message-ID: <20120528021228.GD19152@thunk.org>
References: <4FBD6C3A.1020301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45843 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2E1CMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 May 2012 22:12:32 -0400
Content-Disposition: inline
In-Reply-To: <4FBD6C3A.1020301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 23, 2012 at 06:01:14PM -0500, Eric Sandeen wrote:
> # debugfs -R "icheck 4295032832" testimage
> debugfs 1.42.3 (14-May-2012)
> got block 4295032832 for 4295032832
> got block 65536 for 4295032832
> Block	Inode number
> 65536	<block not found>
> 
> Um, that's no good.
> 
> Affects icheck, freeb, setb, testb...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
