From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: remove unused htree_dump "-l" argument
Date: Sat, 14 May 2011 23:39:43 -0400
Message-ID: <20110515033943.GI21165@thunk.org>
References: <4DCABD5B.8040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49915 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1EODjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 May 2011 23:39:45 -0400
Content-Disposition: inline
In-Reply-To: <4DCABD5B.8040403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 11:46:19AM -0500, Eric Sandeen wrote:
> The long_opt / -l argument was apparently never implemented,
> so remove it and associated argument parsing.
> 
> This slightly changes the (undocumented) behavior because it
> no longer defaults to cwd if no filespec is specified...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the e2fsprogs "next" branch.

					- Ted
