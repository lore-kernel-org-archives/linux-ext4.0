From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] mke2fs: use ext2fs_open_file() in check_plausibility()
Date: Thu, 22 May 2014 13:56:23 -0400
Message-ID: <20140522175623.GB11448@thunk.org>
References: <537CE3E1.10406@redhat.com>
 <537CE6C0.1050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56111 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaEVR40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 13:56:26 -0400
Content-Disposition: inline
In-Reply-To: <537CE6C0.1050800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 12:47:44PM -0500, Eric Sandeen wrote:
> The commit:
> 
> 802146c mke2fs: create a regular file if necessary
> 
> caused a regression on 32-bit machines; the open() fails if
> the file size is > 4G.
> 
> Using ext2fs_open_file() fixes it.
> 
> Resolves: Red Hat Bugzilla #1099892
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
