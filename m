From: Josef Bacik <jbacik@redhat.com>
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Wed, 2 Apr 2008 15:27:15 -0400
Message-ID: <20080402192715.GA32454@unused.rdu.redhat.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <6495.1207163569@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	eparis@redhat.com
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbYDBTdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2008 15:33:24 -0400
Content-Disposition: inline
In-Reply-To: <6495.1207163569@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2008 at 03:12:49PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> 
> (Yes, I know the kernel is tainted.  Hopefully the traceback will make
> enough sense that it won't matter.  I think I cc'd most everybody who is
> listed in MAINTAINERS or had a non-trivial jbd, quota, or ext3 patch in the broken-out/)
> 
> So I was running a 'yum update' on my laptop, walked away to ask a cow-orker
> a question, and came back to find it had BUG'ed twice...  Amazingly
> enough, although it died in ext3 code, it apparently only nuked whatever
> filesystem it was handling, as syslog was still able to log the gory details
> into a file in /var. Given that a kernel rpm was the one it failed on, the
> I/O was almost certainly on either / or /boot - both ext3. / is mounted
> with quotas, /boot isn't, so I'm betting on /
> 
> Apr  2 13:48:07 turing-police yum: Updated: texlive-texmf-latex-2007-18.fc9.noarch
> Apr  2 13:48:08 turing-police yum: Updated: 1:openoffice.org-xsltfilter-2.4.0-12.4.fc9.x86_64
> Apr  2 13:48:09 turing-police yum: Updated: 1:openoffice.org-javafilter-2.4.0-12.4.fc9.x86_64
> Apr  2 13:48:12 turing-police yum: Updated: kernel-headers-2.6.25-0.185.rc7.git6.fc9.x86_64
> 
> (here, it started updating kernel-2.6.25-0.185.rc7.git6 and died while I wasn't looking)

<snip>

Try this patch, it will keep us from re-entering the fs when we aren't supposed
to.  cc'ing Eric Paris since he's the only selinux guy I know :).  I don't think
any of the other allocations in here need to be fixed, but I didn't look too
carefully.

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c2fef7b..820d07a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -180,7 +180,7 @@ static int inode_alloc_security(struct inode *inode)
 	struct task_security_struct *tsec = current->security;
 	struct inode_security_struct *isec;
 
-	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
+	isec = kmem_cache_zalloc(sel_inode_cache, GFP_NOFS);
 	if (!isec)
 		return -ENOMEM;
 
@@ -2429,7 +2429,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 		return -EOPNOTSUPP;
 
 	if (name) {
-		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_KERNEL);
+		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
 		if (!namep)
 			return -ENOMEM;
 		*name = namep;
