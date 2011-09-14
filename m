From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: fix invalid lseek error detection
Date: Wed, 14 Sep 2011 13:28:00 -0400
Message-ID: <20110914172800.GH3429@dhcp-172-31-195-159.cam.corp.google.com>
References: <1314172834-18424-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47433 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab1INR2C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 13:28:02 -0400
Content-Disposition: inline
In-Reply-To: <1314172834-18424-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 24, 2011 at 10:00:34AM +0200, Lukas Czerner wrote:
> In flush_l2_cache() we are using ext2fs_llseek() however we do not
> properly detect the error code returned from the function, because we
> are assigning it into ULL variable, hence we will not see negative
> values.
> 
> Fix this by changing the type of the variable to ext2_loff_t which is
> signed and hence will store negative values.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
