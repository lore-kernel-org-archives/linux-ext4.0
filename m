From: tytso@mit.edu
Subject: Re: [PATCH V2] Add flag to files with blocks intentionally past EOF
Date: Wed, 24 Feb 2010 11:26:21 -0500
Message-ID: <20100224162621.GD5166@thunk.org>
References: <4B5627EF.3080804@redhat.com>
 <4B58963E.4080007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46918 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab0BXQ0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 11:26:22 -0500
Content-Disposition: inline
In-Reply-To: <4B58963E.4080007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 21, 2010 at 12:00:30PM -0600, Eric Sandeen wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> fallocate() may potentially instantiate blocks past EOF, depending
> on the flags used when it is called.
> 
> e2fsck currently has a test for blocks past i_size, and it
> sometimes trips up - noticeably on xfstests 013 which runs fsstress.
> 
> This patch from Jiayang does fix it up - it (along with
> e2fsprogs updates and other patches recently from Aneesh) has
> survived many fsstress runs in a row.
> 
> 
> (Eric Sandeen: removed ioctl interface and minor cleanups)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the maint branch, although I added back the ability to
truncate the fallocated blocks via chattr.

						- Ted
