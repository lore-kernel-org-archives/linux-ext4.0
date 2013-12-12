From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix problem comments to match actual message
Date: Wed, 11 Dec 2013 20:11:00 -0500
Message-ID: <20131212011100.GA4168@thunk.org>
References: <1382414047-93725-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39093 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3LLBLE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Dec 2013 20:11:04 -0500
Content-Disposition: inline
In-Reply-To: <1382414047-93725-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 21, 2013 at 09:54:07PM -0600, Andreas Dilger wrote:
> Fix the e2fsck problem comments to match the actual message printed,
> so that it is possible to find the problem code when searching by
> the message.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

					- Ted
