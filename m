From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd/jbd2: validate sb->s_first in
 journal_get_superblock()
Date: Tue, 1 Nov 2011 19:16:27 -0400
Message-ID: <20111101231626.GN32161@thunk.org>
References: <1320113103-27406-1-git-send-email-guaneryu@gmail.com>
 <20111101222955.GE18701@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43873 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1KAXQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:16:28 -0400
Content-Disposition: inline
In-Reply-To: <20111101222955.GE18701@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:29:55PM +0100, Jan Kara wrote:
>   Thanks. I've fixed-up the style problems pointed out by Andreas and added
> the patch to my tree.

Oops, I grabbed it too.  How do you want to resolve this?  I can just
carry the jbd2 change, or I can carry both, or I can let you carry
both.  Either is fine with me.  (And if we both carry it git should do
the right thing anyway.  :-)

						- Ted
