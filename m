From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] quota: Remove unnecessary definitions
Date: Mon, 23 Jan 2012 16:09:22 -0500
Message-ID: <20120123210922.GA17974@thunk.org>
References: <1327004329-6909-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43142 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2AWXmO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 18:42:14 -0500
Content-Disposition: inline
In-Reply-To: <1327004329-6909-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 19, 2012 at 09:18:49PM +0100, Jan Kara wrote:
> 
>  Ted, after applying this patch, you'll need to run 'make depend' to fixup
> dependencies in makefiles. I didn't include that in the patch because on my
> system the dependencies are different and so diff is 1500+ lines.
> 
> Also I've talked with Aditya and there's no real reason for libquota to be a
> separate library. So I think it would be best to just make it part of
> libext2fs. Do you agree?

My current thinking is to rename it to libinternal, and only build it
statically.  It has all sorts of namespace leakage issues, and it's
not clear any programs outside of e2fsprogs would need it any way.
What do folks think?

						- Ted
