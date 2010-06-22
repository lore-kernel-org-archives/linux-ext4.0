From: tytso@mit.edu
Subject: Re: Updated ext4 quota design document
Date: Tue, 22 Jun 2010 16:08:53 -0400
Message-ID: <20100622200853.GD6843@thunk.org>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
 <20100622142047.GF3338@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47627 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0FVUIz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jun 2010 16:08:55 -0400
Content-Disposition: inline
In-Reply-To: <20100622142047.GF3338@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 04:20:47PM +0200, Jan Kara wrote:
>   It might be reasonable to checksum dquots so that we get closer to
> all-metadata-are-checksummed state. I'm just thinking whether checksumming
> each dquot is so useful. For example OCFS2 checksums each quota block. That
> has an advantage that also quota file tree blocks and headers are
> protected. Also it's possible to use the generic block checksumming
> framework in JBD2 for this case. OTOH ext4 seems to have chosen to checksum
> each group descriptor individually so checksumming each dquot structure
> would seem more consistent.

Well, the reason why I suggested just checksuming the each quota entry
is that it was the simplest thing to do, and wouldn't require making
huge changes to the rest of the quota_tree code.  It also means we
don't need to do any kind of special locking to make sure there isn't
another process modifying another quota entry in the same block at the
same time that we are calculating the per-block checksum --- i.e.,
some of the headaches that we're seeing with the DIF code.

>   So I don't have a strong opinion which checksumming scheme should be
> chosen. I just wanted to point out that there's another reasonable option.
> Generic quota code can easily handle both (including leaving some bytes at
> the end of each block for checksums as it does for OCFS2 now).

I assume OCFS2 is just using dqdh_pad2 or dqdh_pad1 for its checksum?

  	       	       	     	       	  	    - Ted
