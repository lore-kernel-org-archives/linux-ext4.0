From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not enable delalloc by default for ext2
Date: Mon, 17 Sep 2012 22:59:32 -0400
Message-ID: <20120918025932.GA22999@thunk.org>
References: <4F71C4B3.9090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51203 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2IRC7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 22:59:37 -0400
Content-Disposition: inline
In-Reply-To: <4F71C4B3.9090402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 27, 2012 at 09:46:27AM -0400, Brian Foster wrote:
> Use traditional ext2 mount options. Do not enable delalloc by default for ext2.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Thanks, applied.

						- Ted
