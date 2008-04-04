From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Fri, 4 Apr 2008 12:15:09 +0200
Message-ID: <20080404101509.GB477@atrey.karlin.mff.cuni.cz>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <6495.1207163569@turing-police.cc.vt.edu> <20080402192715.GA32454@unused.rdu.redhat.com> <20080402123905.386c56f8.akpm@linux-foundation.org> <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <jbacik@redhat.com>, Valdis.Kletnieks@vt.edu,
	sct@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, eparis@redhat.com,
	James Morris <jmorris@namei.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYDDKPL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 06:15:11 -0400
Content-Disposition: inline
In-Reply-To: <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Wed, 2008-04-02 at 12:39 -0700, Andrew Morton wrote:
> > On Wed, 2 Apr 2008 15:27:15 -0400
> > Josef Bacik <jbacik@redhat.com> wrote:
> > 
> > > On Wed, Apr 02, 2008 at 03:12:49PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> > > > 
> > > > (Yes, I know the kernel is tainted.  Hopefully the traceback will make
> > > > enough sense that it won't matter.  I think I cc'd most everybody who is
> > > > listed in MAINTAINERS or had a non-trivial jbd, quota, or ext3 patch in the broken-out/)
> > > > 
> > > > So I was running a 'yum update' on my laptop, walked away to ask a cow-orker
> > > > a question, and came back to find it had BUG'ed twice...  Amazingly
> > > > enough, although it died in ext3 code, it apparently only nuked whatever
> > > > filesystem it was handling, as syslog was still able to log the gory details
> > > > into a file in /var. Given that a kernel rpm was the one it failed on, the
> > > > I/O was almost certainly on either / or /boot - both ext3. / is mounted
> > > > with quotas, /boot isn't, so I'm betting on /
> > > > 
> > > > Apr  2 13:48:07 turing-police yum: Updated: texlive-texmf-latex-2007-18.fc9.noarch
> > > > Apr  2 13:48:08 turing-police yum: Updated: 1:openoffice.org-xsltfilter-2.4.0-12.4.fc9.x86_64
> > > > Apr  2 13:48:09 turing-police yum: Updated: 1:openoffice.org-javafilter-2.4.0-12.4.fc9.x86_64
> > > > Apr  2 13:48:12 turing-police yum: Updated: kernel-headers-2.6.25-0.185.rc7.git6.fc9.x86_64
> > > > 
> > > > (here, it started updating kernel-2.6.25-0.185.rc7.git6 and died while I wasn't looking)
> > > 
> > > <snip>
> > > 
> > > Try this patch, it will keep us from re-entering the fs when we aren't supposed
> > > to.  cc'ing Eric Paris since he's the only selinux guy I know :).  I don't think
> > > any of the other allocations in here need to be fixed, but I didn't look too
> > > carefully.
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> > > 
> > > 
> > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > index c2fef7b..820d07a 100644
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -180,7 +180,7 @@ static int inode_alloc_security(struct inode *inode)
> > >  	struct task_security_struct *tsec = current->security;
> > >  	struct inode_security_struct *isec;
> > >  
> > > -	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
> > > +	isec = kmem_cache_zalloc(sel_inode_cache, GFP_NOFS);
> > >  	if (!isec)
> > >  		return -ENOMEM;
> > >  
> > > @@ -2429,7 +2429,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
> > >  		return -EOPNOTSUPP;
> > >  
> > >  	if (name) {
> > > -		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_KERNEL);
> > > +		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
> > >  		if (!namep)
> > >  			return -ENOMEM;
> > >  		*name = namep;
> > 
> > Might fix it.  But 2.6.24's inode_alloc_security() also uses GFP_KERNEL and
> > doesn't have this bug.  What changed?
> 
> Looks legitimate, although we've been doing that since Linux 2.6.0-test3
> (selinux merge) for inode_alloc_security and d_instantiate, and since
> Linux 2.6.14 for inode_init_security, so something is at least
> triggering it more easily now.  inode_doinit_with_dentry looks like
> another instance and security_context_to_sid_core as well.
  I guess it is just the combination of someone using SELinux + quota
(or several journaling filesystems) + being unlucky under memory
pressure that makes this happen only rarely. Josef, have you been
successful in reproducing the problem under older kernel?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
