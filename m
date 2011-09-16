From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/25] mke2fs: free tdb_dir string if it came from the
 profile
Date: Fri, 16 Sep 2011 19:58:13 -0400
Message-ID: <20110916235813.GD16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-26-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60927 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab1IPX6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 19:58:14 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-26-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:40PM -0500, Eric Sandeen wrote:
> if tdb_dir points to a string allocated from profile_get_string,
> it should be freed again before we exit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks!

						- Ted
