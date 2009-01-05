From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] add releasepage hooks to block devices which can
	be used by file systems
Date: Mon, 5 Jan 2009 11:05:14 -0500
Message-ID: <20090105160514.GA8939@mit.edu>
References: <20081226050138.GU28946@ZenIV.linux.org.uk> <1230995358-24013-1-git-send-email-tytso@mit.edu> <1230995358-24013-2-git-send-email-tytso@mit.edu> <4961C1C8.2080300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4961C1C8.2080300@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 05, 2009 at 05:16:08PM +0900, Toshiyuki Okajima wrote:
> 
> I was confirming whether the kernel to which your new patch is
> applied can run without trouble. But unfortunately, I got a hangup
> problem. Now I am investigating the root cause.  After I
> investigated it for a little time, I think calling log_wait_commit()
> from journal_try_to_free_buffers() can cause it.  

Sounds like a deadlock caused by the fact that we're no longer masking
__GFP_WAIT, probably on journal->j_wait_done_commit.  Presumably the
system came under pressure during a commit operation, which makes
sense, and so we ended up with a deadlock between kjournald and
kswapd.  The fix is pretty simple; we just need to mask out the
__GFP_WAIT in the filesystem-specific callback, since this is a
restriction imposed by the filesystem's use of the jbd/jbd2 layer.

	    	       	   		       - Ted
