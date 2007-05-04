From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Date: Fri, 4 May 2007 16:07:31 +1000
Message-ID: <20070504060731.GJ32602149@melbourne.sgi.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53879 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932231AbXEDGIG (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Fri, 4 May 2007 02:08:06 -0400
Content-Disposition: inline
In-Reply-To: <20070503212955.b1b6443c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 03, 2007 at 09:29:55PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > This patch implements the fallocate() system call and adds support for
> > i386, x86_64 and powerpc.
> > 
> > ...
> > +{
> > +	struct file *file;
> > +	struct inode *inode;
> > +	long ret = -EINVAL;
> > +
> > +	if (len == 0 || offset < 0)
> > +		goto out;
> 
> The posix spec implies that negative `len' is permitted - presumably "allocate
> ahead of `offset'".  How peculiar.

I just checked the man page for posix_fallocate() and it says:

      EINVAL  offset or len was less than zero.

We should probably follow this lead.

> > +
> > +	ret = -ENODEV;
> > +	if (!S_ISREG(inode->i_mode))
> > +		goto out_fput;
> 
> So we return ENODEV against an S_ISBLK fd, as per the posix spec.  That
> seems a bit silly of them.

Hmmmm - I thought that the intention of sys_fallocate() was to
be generic enough to eventually allow preallocation on directories.
If that is the case, then this check will prevent that....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
