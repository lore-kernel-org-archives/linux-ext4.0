From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Warn when discard request fails other than
 EOPNOTSUPP
Date: Thu, 8 Nov 2012 14:10:05 -0500
Message-ID: <20121108191005.GG19977@thunk.org>
References: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
 <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60104 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 19, 2012 at 02:12:38PM +0200, Lukas Czerner wrote:
> We should warn user then the discard request fails. However we need to
> exclude -EOPNOTSUPP case since parts of the device might not support it
> while other parts can. So print the kernel warning when the error !=
> -EOPNOTSUPP is returned from ext4_issue_discard().
> 
> We should also handle error cases in batched discard, again excluding
> EOPNOTSUPP.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
