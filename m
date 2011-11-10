From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2: advance group in ext2fs_open2 during swapping
Date: Thu, 10 Nov 2011 07:02:33 -0500
Message-ID: <20111110120233.GR24234@thunk.org>
References: <4EB9AC9B.5020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58747 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab1KJMCh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 07:02:37 -0500
Content-Disposition: inline
In-Reply-To: <4EB9AC9B.5020803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 08, 2011 at 04:26:35PM -0600, Eric Sandeen wrote:
> Without this change, we go back to getting group descriptor
> "0" each time we go around the "for i" loop.  It must properly
> advance through the filesystem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
