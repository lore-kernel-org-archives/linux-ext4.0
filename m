From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Use kstrtoul() instead of deprecated
 simple_strtoul()
Date: Sun, 10 Mar 2013 22:26:35 -0400
Message-ID: <20130311022635.GG10090@thunk.org>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
 <1362730998-3263-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52363 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3CKC0h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 22:26:37 -0400
Content-Disposition: inline
In-Reply-To: <1362730998-3263-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 08, 2013 at 09:23:17AM +0100, Lukas Czerner wrote:
> In parse_strtoul() we're still using deprecated simple_strtoul(). Change
> that in favour of kstrtoul().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Once you make this change, wouldn't it be better and even more
simplifying to replace the two places where we call parse_strtoul()
with kstrtoul()?

					- Ted
