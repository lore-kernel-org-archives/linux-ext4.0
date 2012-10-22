From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Avoid underflow of in ext4_trim_fs()
Date: Mon, 22 Oct 2012 00:37:21 -0400
Message-ID: <20121022043721.GD4768@thunk.org>
References: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
 <1349944485-13868-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56749 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2JVEh0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2012 00:37:26 -0400
Content-Disposition: inline
In-Reply-To: <1349944485-13868-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2012 at 10:34:45AM +0200, Lukas Czerner wrote:
> Currently if len argument in ext4_trim_fs() is smaller than one block,
> the 'end' variable underflow. Avoid that by returning EINVAL if len is
> smaller than file system block.
> 
> Also remove useless unlikely().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
