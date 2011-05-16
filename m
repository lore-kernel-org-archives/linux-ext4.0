From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix NULL pointer dereference in ext4_quota_off
Date: Mon, 16 May 2011 10:04:35 -0400
Message-ID: <20110516140435.GA4953@thunk.org>
References: <BANLkTin4vEQZ4W5LQT36U3BVxWG4VeDZYw@mail.gmail.com>
 <20110516101154.GB5344@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37323 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1EPOEk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 10:04:40 -0400
Content-Disposition: inline
In-Reply-To: <20110516101154.GB5344@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 12:11:54PM +0200, Jan Kara wrote:
>   Ah, I see we worked on the patch together :). Anyway, Ted can pick any of
> them I guess.

I actually combined the commit description and used elements from both
of them.  Jan's short description was a better summary, but I liked
Amir description of the commit (note though that if you're going to
use abberviated git commit id's, please don't shorten them to 10-12
characters since given the size of the git repository, shorter git
commit id's could suffer from hash collision).

						- Ted

ext4: fix oops in ext4_quota_off()

From: Amir Goldstein <amir73il@gmail.com>

If quota is not enabled when ext4_quota_off() is called, we must not
dereference quota file inode since it is NULL.  Check properly for
this.

This fixes a bug in commit 21f976975cbe (ext4: remove unnecessary
[cm]time update of quota file), which was merged for 2.6.39-rc3.

Reported-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
