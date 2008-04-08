From: Josef Bacik <jbacik@redhat.com>
Subject: Re: Ordered mode rewrite patch
Date: Tue, 8 Apr 2008 11:47:04 -0400
Message-ID: <20080408154704.GO22429@unused.rdu.redhat.com>
References: <20080408121149.GB6901@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311AbYDHP7X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 11:59:23 -0400
Content-Disposition: inline
In-Reply-To: <20080408121149.GB6901@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
>   Hello,
> 
>   attached is a jumbo patch that reverses locking order of transaction
> start and page lock in ext3 and rewrites handling of ordered data mode in
> JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
> The patch survives LTP run on my test machine so it shouldn't eat your data
> immediately but bugs are of course possible...
>   I'm very interested in any results (both positive and negative) you could
> get with it :). Thanks for testing it.
> 
> 									Honza
> 
> PS: CCing also linux-ext4 list in case there are some other interested
> testers. Next on my todo list is to port this for ext4...
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

Just glancing over it everything looks to be ok, but I still can't compile with
ext3/jbd being modules :).  I had to EXPORT_SYMBOL do_writepages,
__filemap_fdatawrite_range and all the jbd things you added to make it build
properly.  I will do some testing with it while I'm in class.

Josef
