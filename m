From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: reserve metadata block for every delayed write
Date: Sun, 10 Mar 2013 22:52:19 -0400
Message-ID: <20130311025219.GK10090@thunk.org>
References: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
 <1362731059-3508-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52382 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3CKCwX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 22:52:23 -0400
Content-Disposition: inline
In-Reply-To: <1362731059-3508-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 08, 2013 at 09:24:19AM +0100, Lukas Czerner wrote:
> Currently we only reserve space (data+metadata) in delayed allocation if
> we're allocating from new cluster (which is always in non-bigalloc file
> system) which is ok for data blocks, because we reserve whole cluster.
> 
> However we have to reserve metadata for every delayed block we're going
> to write because every block could potentially require metedata block
> when we need to grow the extent tree.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
