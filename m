From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libquota: don't include system quota.h header
Date: Mon, 27 Feb 2012 01:28:51 -0500
Message-ID: <20120227062851.GD14204@thunk.org>
References: <1330069432-35919-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35521 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab2B0G2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 01:28:55 -0500
Content-Disposition: inline
In-Reply-To: <1330069432-35919-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 12:43:52AM -0700, Andreas Dilger wrote:
> Don't use the system <sys/quota.h> header in mkquota.c, since there
> is a local e2fsprogs version of quota.h that is already included and
> has the desired quota constants, and avoids symbol conflicts with the
> system <sys/quota.h> on other platforms (in particular OSX).
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

					- Ted
