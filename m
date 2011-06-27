From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: clone indirect.c file from inode.c
Date: Mon, 27 Jun 2011 19:41:56 -0400
Message-ID: <20110627234156.GG2729@thunk.org>
References: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
 <1308649168-12543-4-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60727 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab1F0XmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 19:42:04 -0400
Content-Disposition: inline
In-Reply-To: <1308649168-12543-4-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 12:39:27PM +0300, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> The next patch is going to move ext4_ind_ functions to
> indirect.c. First, we clone the file from inode.c and
> only leave code that is going to be duplicated in both files.
> This should keep the deleted lines count from inode.c in the next
> patch the same as the added lines count to indirect.c.

I really dislike cloning functions.  This becomes a maintenance
headache, since bugs that get fixed in one file might not get
propagated to another.  Since I need to manually move all of the
functions to verify nothing else changed in patches that do massive
code movement, I used the first two patches in your patch series, but
replaced the last two patches in the patch series, and replaced it
with the following:

A) Move __ext4_check_blockref() to fs/ext4/block_validity.c and
declare it extern.

B) Move ext4_truncate_failed_write() and blocks_for_truncate() to a
new function, fs/ext4/truncate.h.

C) Movement of indirect-related code to fs/ext4/indirect.c.

   	       			     	- Ted
