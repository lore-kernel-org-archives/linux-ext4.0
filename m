From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fixed tracepoints cleanup
Date: Mon, 6 Jun 2011 09:56:50 -0400
Message-ID: <20110606135650.GJ7180@thunk.org>
References: <1307268028-6974-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45569 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1FFN4x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 09:56:53 -0400
Content-Disposition: inline
In-Reply-To: <1307268028-6974-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 05, 2011 at 12:00:28PM +0200, Lukas Czerner wrote:
> While creating fixed tracepoints for ext3, basically by porting them
> from ext4, I found a lot of useless retyping, wrong type usage, useless
> variable passing and other inconsistencies in the ext4 fixed tracepoint
> code.
> 
> This patch cleans the fixed tracepoint code for ext4 and also simplify
> some of them.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Added to the ext4 tree, thanks.

						- Ted
