From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] Ext4: No need to add inode to orphan list during
 hole punch
Date: Sat, 18 Aug 2012 22:30:41 -0400
Message-ID: <20120819023041.GB15763@thunk.org>
References: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lczerner@redhat.com, a.sangwan@samsung.com,
	namjae.jeon@samsung.com,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45552 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2HSCaq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Aug 2012 22:30:46 -0400
Content-Disposition: inline
In-Reply-To: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 07:53:34PM +0530, Ashish Sangwan wrote:
> While performing punch hole for an inode, i_disksize is not changed.
> So, there is no need to add the inode to orphan list.
> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Thanks, applied.

						- Ted
