From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] tune2fs: preserve old limits when turn on quota
 feature
Date: Mon, 14 Nov 2011 10:59:35 -0500
Message-ID: <20111114155935.GE7698@thunk.org>
References: <4EB68DF8.7030608@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com, linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38445 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1KNP7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:59:37 -0500
Content-Disposition: inline
In-Reply-To: <4EB68DF8.7030608@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 06, 2011 at 09:39:04PM +0800, Niu wrote:
> When turn on quota by tune2fs, if the old quota file exist, the quota
> usage should be recomputed but the old limits should be preserved.
> 
> Signed-off-by: Niu Yawei <niu@whamcloud.com>

Thanks, applied.

Note: it looks like we need a similar fix for e2fsck, so that the
limits are preserved, right?  From what I can tell a patch to fix this
hasn't crossed my desk yet....

					- Ted
