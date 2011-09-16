From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5 v2] e2fsck: do not attempt to discard if -n was
 specified
Date: Thu, 15 Sep 2011 23:53:31 -0400
Message-ID: <20110916035331.GU28181@thunk.org>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
 <1313167380-3283-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33884 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1IPDxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:53:34 -0400
Content-Disposition: inline
In-Reply-To: <1313167380-3283-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 06:42:59PM +0200, Lukas Czerner wrote:
> If '-n' option is specified there should be no changes made to the file
> system hence we should not attempt to discard the file system. This
> commit adds a check into the e2fsck_discard_blocks() condition so it skip
> discard if E2F_OPT_NO flag is set.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied to the next branch.

					- Ted
