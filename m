From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/25] e2fsck: Don't store old_op from
 ehandler_operation if we don't restore it.
Date: Fri, 16 Sep 2011 18:55:39 -0400
Message-ID: <20110916225539.GO16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-13-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56170 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab1IPWzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:55:41 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-13-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:27PM -0500, Eric Sandeen wrote:
> old_op is set but never used, because we restore "0"
> not old_op.  So don't bother with it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

				- Ted
