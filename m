From: Jan Kara <jack@suse.cz>
Subject: Re: Ordered mode rewrite patch
Date: Tue, 8 Apr 2008 23:10:52 +0200
Message-ID: <20080408211052.GC21869@duck.suse.cz>
References: <20080408121149.GB6901@duck.suse.cz> <20080408154704.GO22429@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53424 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314AbYDHVKx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 17:10:53 -0400
Content-Disposition: inline
In-Reply-To: <20080408154704.GO22429@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-04-08 11:47:04, Josef Bacik wrote:
> On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   attached is a jumbo patch that reverses locking order of transaction
> > start and page lock in ext3 and rewrites handling of ordered data mode in
> > JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
> > The patch survives LTP run on my test machine so it shouldn't eat your data
> > immediately but bugs are of course possible...
> >   I'm very interested in any results (both positive and negative) you could
> > get with it :). Thanks for testing it.
> > 
> > 									Honza
> > 
> > PS: CCing also linux-ext4 list in case there are some other interested
> > testers. Next on my todo list is to port this for ext4...
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> Just glancing over it everything looks to be ok, but I still can't compile with
> ext3/jbd being modules :).  I had to EXPORT_SYMBOL do_writepages,
> __filemap_fdatawrite_range and all the jbd things you added to make it build
> properly.  I will do some testing with it while I'm in class.
  Strange, I've already been fixing these. Aww, I thought diff contained
all the changes and obviously the branch in git contained some further
fixes :(. Hopefully I've at least committed changes and will be able to
find fixes among git objects...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
