From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4 inline cleanup patches
Date: Thu, 12 Jan 2017 09:46:57 -0500
Message-ID: <20170112144657.p33nf3u3ev27ixjq@thunk.org>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112091254.31257.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39080 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbdALOrB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 12 Jan 2017 09:47:01 -0500
Content-Disposition: inline
In-Reply-To: <20170112091254.31257.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2017 at 04:12:54AM -0500, George Spelvin wrote:
> It *seems* to work, although it doesn't apply to v4.9.x (because
> ext4_truncate returns void in that version), and I ran into two
> unrelared bugs in v4.10-rc3 before I was able to test.
> 
> I'll probably go back to v4.9.x and leave off patch 4/4.

Yes, 4/4 isn't needed to fix your issue.  It's just that once i opened
up inline.c, I saw some other things I wanted to fix.

	    	     	   	    	   - Ted
