From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] misc: quiet minor compiler errors
Date: Sat, 24 Sep 2011 14:49:09 -0400
Message-ID: <20110924184909.GD2779@thunk.org>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48273 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1IXStN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 14:49:13 -0400
Content-Disposition: inline
In-Reply-To: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 05:38:41PM -0600, Andreas Dilger wrote:
> Several compiler errors are quieted:
> - zero-length gnu_printf format string
> - unused variable
> - uninitalized variable (though it isn't actually used for anything)
> - use of stat64/open64 on OSX (deprecated API)
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied, thanks.

						- Ted
