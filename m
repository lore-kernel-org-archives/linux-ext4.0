From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Fix overflow when counting used blocks on
 32-bit architectures
Date: Fri, 31 May 2013 19:42:24 -0400
Message-ID: <20130531234224.GB23048@thunk.org>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
 <1369829133-4307-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53851 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3EaXm3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 19:42:29 -0400
Content-Disposition: inline
In-Reply-To: <1369829133-4307-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 29, 2013 at 02:05:33PM +0200, Jan Kara wrote:
> The arithmetics adding delalloc blocks to the number of used blocks in
> ext4_getattr() can easily overflow on 32-bit archs as we first multiply
> number of blocks by blocksize and then divide back by 512. Make the
> arithmetics more clever and also use proper type (unsigned long long
> instead of unsigned long).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I've applied these four patches to the ext4 tree, thanks!!

     	     	   		       - Ted
