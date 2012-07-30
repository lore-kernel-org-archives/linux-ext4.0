From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext2fs.h: Chnage the way
 EXT2_LIB_FEATURE_INCOMPAT_SUPP deals with optional features.
Date: Mon, 30 Jul 2012 15:40:47 -0400
Message-ID: <20120730194047.GA10343@thunk.org>
References: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42086 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2G3Tkw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 15:40:52 -0400
Content-Disposition: inline
In-Reply-To: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:42:14AM +1000, Tony Breeds wrote:
> Currently EXT2_LIB_FEATURE_INCOMPAT_SUPP is #defined twice once with
> EXT2_FEATURE_INCOMPAT_COMPRESSION and once without depending on the
> state of ENABLE_COMPRESSION
> 
> Change this to use an intermediate symbol so that the definition of
> EXT2_LIB_FEATURE_INCOMPAT_SUPP doesn't change as other optional fetures
> are added.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Added to the next branch of e2fsprogs.

					- Ted
