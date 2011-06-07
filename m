From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Don't erase flash device if "-n" is given
Date: Tue, 7 Jun 2011 13:37:36 -0400
Message-ID: <20110607173736.GC30037@thunk.org>
References: <1307463749-16498-1-git-send-email-adilger@whamcloud.com>
 <4DEE58C0.3040303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41162 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab1FGRhm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 13:37:42 -0400
Content-Disposition: inline
In-Reply-To: <4DEE58C0.3040303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 07, 2011 at 11:58:40AM -0500, Eric Sandeen wrote:
> On 6/7/11 11:22 AM, Andreas Dilger wrote:
> > If "mke2fs -n" is used, there should be no changes to the underlying
> > device.  Unfortunately, when the "discard" option was added in commit
> > c7cd908be59f48c66b4f3ac9a631ffe3dde4f1ab, it did not check for the "-n"
> > flag, and will discard all data on a flash device even if "-n" is given.
> 
> Oh, crud.

I guess that means we should probably release e2fsprogs 1.41.15.

> > Check for the "noaction" flag before discarding any filesystem data.
> > 
> > Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Added to the maint branch, thanks.

						- Ted
