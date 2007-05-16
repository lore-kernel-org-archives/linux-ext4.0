From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64 and powerpc
Date: Wed, 16 May 2007 18:01:24 +0530
Message-ID: <20070516123124.GA24299@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com> <20070515200359.GA5834@amitarora.in.ibm.com> <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46786 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbXEPMbd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 May 2007 08:31:33 -0400
Content-Disposition: inline
In-Reply-To: <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 15, 2007 at 05:42:46PM -0700, Mingming Cao wrote:
> On Wed, 2007-05-16 at 01:33 +0530, Amit K. Arora wrote:
> > This patch implements sys_fallocate() and adds support on i386, x86_64
> > and powerpc platforms.
> 
> > @@ -1137,6 +1148,8 @@ struct inode_operations {
> >  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> >  	int (*removexattr) (struct dentry *, const char *);
> >  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> > +	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
> > +			  loff_t len);
> >  };
> 
> Does the return value from fallocate inode operation has to be *long*?
> It's not consistent with the ext4_fallocate() define in patch 4/5, 

I think ->fallocate() should return a "long", since sys_fallocate() has
to return what ->fallocate() returns and hence their return type should
ideally match.
 
> +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t
> len)

I will change the ext4_fallocate() to return a "long" (in patch 4/5)
in the next post.

Agree ?

Thanks!
--
Regards,
Amit Arora

> 
> thus cause compile warnings.
> 
> 
> 
> Mingming
