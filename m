From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release donor reference when EXT4_IOC_MOVE_EXT
 ioctl fails
Date: Wed, 26 Sep 2012 22:59:26 -0400
Message-ID: <20120927025925.GD15707@thunk.org>
References: <20120106215013.GA27957@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52626 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2I0C7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 22:59:30 -0400
Content-Disposition: inline
In-Reply-To: <20120106215013.GA27957@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 06, 2012 at 10:50:13PM +0100, Djalal Harouni wrote:
> When the EXT4_IOC_MOVE_EXT ioctl() fails on bigalloc file systems, we
> should jump to the 'mext_out' label to release the donor file reference.
> 
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>

Thanks, applied!

					- Ted
