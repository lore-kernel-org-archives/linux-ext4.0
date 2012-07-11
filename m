From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Implement subtree ID support for ext4
 filesystem
Date: Wed, 11 Jul 2012 13:17:10 -0400
Message-ID: <20120711171710.GA8073@thunk.org>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
 <1341847725-26114-3-git-send-email-dmonakhov@openvz.org>
 <20120709210439.GB11960@thunk.org>
 <874npefo7n.fsf@dmbot.sw.ru>
 <20120711132429.GA10872@thunk.org>
 <87vchue2u6.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2GKRRO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 13:17:14 -0400
Content-Disposition: inline
In-Reply-To: <87vchue2u6.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 07:26:25PM +0400, Dmitry Monakhov wrote:
> Yes this looks reasonable, the only thing that we should aware of is id
> collision. We have to reserve pool numbers to quota group id's.
> This can be easily solved by changing disk structure of quota-file
> to use u64 on uid.

How many pool id's are you anticipating?  Is 32-bits really not
enough?  I'll note that uid_t and gid_t is only 32-bits today, and
part of my goal is to try to preserve compatibility with the existing
quota infrastructure.

							- Ted
