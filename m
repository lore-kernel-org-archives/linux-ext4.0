From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/2] Fix dirtying of journalled buffers in data=journal
 mode
Date: Thu, 5 Aug 2010 15:09:25 -0400
Message-ID: <20100805190925.GJ2901@thunk.org>
References: <1281026536-10413-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35166 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0HETJa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 15:09:30 -0400
Content-Disposition: inline
In-Reply-To: <1281026536-10413-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 06:42:14PM +0200, Jan Kara wrote:
> 
>   this is a second attempt to fix "JBD: Spotted dirty metadata buffer"
> warnings from JBD/JBD2. This time I've found a much less hacky fix so
> I'm now satisfied. fsx-linux in data=journal mode now runs without warning
> for me. Ted, will you merge the ext4 patch, please? I'll merge the ext3 patch
> if noone objects...

Looks good to me; feel free to add an:

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

to the ext3 patch.

The ext4 patch has survived my testing, and I've added it to the ext4
patch tree.

							- Ted
