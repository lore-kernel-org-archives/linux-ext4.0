From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/12] ext4: Move work from io_end to inode
Date: Mon, 28 Jan 2013 09:45:28 -0500
Message-ID: <20130128144528.GF22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45865 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab3A1Opb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:45:31 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:40PM +0100, Jan Kara wrote:
> It does not make much sense to have struct work in ext4_io_end_t because we
> always use it for only one ext4_io_end_t per inode (the first one in the
> i_completed_io list). So just move the structure to inode itself.  This also
> allows for a small simplification in processing io_end structures.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

(Note, I haven't applied patch 5 yet because it has a dependency on
patch #4, and I'm waiting to hear whether we should apply this given
the race condition which Dmitry has found.  It sounds like it's a
pre-existing condition, and not a regression, but I want get a
confirmation that applying patches 5 and 6 won't make things worse...)

	     	  	   	     	   - Ted
