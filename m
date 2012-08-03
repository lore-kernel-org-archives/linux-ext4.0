From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7] libext2fs: enforce the block group descriptor size
 in ext2fs_open()
Date: Thu, 2 Aug 2012 20:00:03 -0400
Message-ID: <20120803000003.GA4253@thunk.org>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
 <1343684862-13181-7-git-send-email-tytso@mit.edu>
 <B4B1A06B-F856-4248-8A7E-3BFF8F3E7267@whamcloud.com>
 <20120731200918.GF32228@thunk.org>
 <CD3F0352-A252-4427-AE7B-F71160BF77BC@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42735 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2HCAAI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Aug 2012 20:00:08 -0400
Content-Disposition: inline
In-Reply-To: <CD3F0352-A252-4427-AE7B-F71160BF77BC@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 01:45:32PM -0700, Andreas Dilger wrote:
> 
> I'm pretty sure that we've always checked that it is a power-of-two
> value. The problem with this change is that it makes it much harder
> to increase the size again in the future .

Unfortunately, no, there aren't any such checks anywhere in either the
kernel or e2fsck.  In fact, e2fsck wasn't checking s_desc_size at all
(although it was depending on it), which is what caused me to get very
worried...

> It would definitely need another feature flag, but it isn't clear
> without more investigation (that i can't do on my phone) if a COMPAT
> flag would be enough (which we would likely have anyway if we needed
> a larger descriptor) or if we need a more restrictive feature flag.

It seems very likely that any new feature that would require us to
expand the block group descriptor would require other changes to the
file system's structures that would require a more restrictive
feature flag....

						- Ted


		
