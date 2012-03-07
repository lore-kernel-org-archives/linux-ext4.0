From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: check for fallocate symbol before using it
Date: Tue, 6 Mar 2012 20:22:06 -0500
Message-ID: <20120307012206.GD5717@thunk.org>
References: <1330925795-12358-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40358 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab2CGQWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 11:22:42 -0500
Content-Disposition: inline
In-Reply-To: <1330925795-12358-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 12:36:35AM -0500, Mike Frysinger wrote:
> If we have newer kernel headers which define FALLOC_FL_PUNCH_HOLE, but we
> are on an older glibc which lacks fallocate, we end up trying to use the
> func anyways.  Check the ifdef that autoconf already set up for us.
> 
> Reported-by: Ortwin Glueck <odi@odi.ch>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

						- Ted
