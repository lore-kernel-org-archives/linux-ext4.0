From: Theodore Tso <tytso@mit.edu>
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Date: Mon, 23 Mar 2009 23:05:03 -0400
Message-ID: <20090324030503.GI5814@mit.edu>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com> <20090320221750.GA32416@kroah.com> <20090323024404.GA14082@mit.edu> <20090324001325.GA1909@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
	Greg KH <gregkh@suse.de>, mfasheh@suse.com,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, Dan Carpenter <error27@gmail.com>,
	mfasheh@suse.de, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51174 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZCXDGR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2009 23:06:17 -0400
Content-Disposition: inline
In-Reply-To: <20090324001325.GA1909@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:13:25PM -0700, Greg KH wrote:
> On Sun, Mar 22, 2009 at 10:44:04PM -0400, Theodore Tso wrote:
> > On Fri, Mar 20, 2009 at 03:17:50PM -0700, Greg KH wrote:
> > > 
> > > I tracked this down to commit 54dc90 in the 2.6.28.8 tree.
> > > 
> > > I've included it below.  Jan and Ted, any ideas on how to fix this
> > > error?
> > 
> > 2.6.29 dropped the CONFIG_OCFS2_COMPAT_JBD option; if you enable it,
> > causes a compile failure in 2.6.28.8.  This should fix it...
> 
> Can you send it in a format that I can apply it in?

Will do.  I have a batch of final patches that went in right before
2.6.29, I'll include it those patches.

						- Ted
