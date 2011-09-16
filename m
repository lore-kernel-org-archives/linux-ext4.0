From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/25] tune2fs: handle inode and/or block bitmap read
 failures in resize_inode()
Date: Fri, 16 Sep 2011 19:57:35 -0400
Message-ID: <20110916235735.GA16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-23-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48990 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1IPX5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 19:57:37 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-23-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:37PM -0500, Eric Sandeen wrote:
> Handle these failures in resize_inode, and handle the propagated
> error in the caller.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
