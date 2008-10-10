From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix blkid detection of ext4dev as ext4
Date: Fri, 10 Oct 2008 13:49:19 -0400
Message-ID: <20081010174919.GB8645@mit.edu>
References: <48ECFD21.3080203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47482 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932091AbYJJRtV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 13:49:21 -0400
Content-Disposition: inline
In-Reply-To: <48ECFD21.3080203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 08, 2008 at 01:34:09PM -0500, Eric Sandeen wrote:
> If only ext4 is available (as a module or in /proc/filesystems)
> blkid wasn't properly testing for it, because the time checks
> were backwards and always failed.  This caused old ext4dev
> filesystems to fail to mount as ext4.  With this patch it works
> fine.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

thanks, applied.

						- Ted
