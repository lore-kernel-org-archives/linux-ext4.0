From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Date: Tue, 24 Mar 2009 12:05:39 -0700
Message-ID: <20090324190539.GG13065@wotan.suse.de>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com> <20090320221750.GA32416@kroah.com> <20090323024404.GA14082@mit.edu>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Jan Kara <jack@suse.cz>, Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42791 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZCXTYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2009 15:24:39 -0400
Content-Disposition: inline
In-Reply-To: <20090323024404.GA14082@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 22, 2009 at 10:44:04PM -0400, Theodore Tso wrote:
> On Fri, Mar 20, 2009 at 03:17:50PM -0700, Greg KH wrote:
> > 
> > I tracked this down to commit 54dc90 in the 2.6.28.8 tree.
> > 
> > I've included it below.  Jan and Ted, any ideas on how to fix this
> > error?
> 
> 2.6.29 dropped the CONFIG_OCFS2_COMPAT_JBD option; if you enable it,
> causes a compile failure in 2.6.28.8.  This should fix it...
> 
> diff --git a/fs/ocfs2/ocfs2_jbd_compat.h b/fs/ocfs2/ocfs2_jbd_compat.h
> index b91c78f..268949b 100644
> --- a/fs/ocfs2/ocfs2_jbd_compat.h
> +++ b/fs/ocfs2/ocfs2_jbd_compat.h
> @@ -60,7 +60,8 @@ static inline int jbd2_journal_file_inode(handle_t *handle,
>  	return 0;
>  }
>  
> -static inline int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
> +static inline int jbd2_journal_begin_ordered_truncate(journal_t *journal,
> +						      struct jbd2_inode *inode,
>  						      loff_t new_size)
>  {
>  	return 0;
> 
> > Should I just revert this from the 2.6.28 tree?  Or does no one really
> > care about ocfs2 in the stable tree?
> 
> I'm not sure how much people will care about CONFIG_OCFS2_COMPAT_JBD,
> given that it disappears in 2.6.29, but the above patch should fix
> things.

CONFIG_OCFS2_COMPAT_JBD is off by default, and existed for a really short
time so I don't think it'll matter much if it's broken (obviously fixing it
is better). Btw, people definitely use Ocfs2 in the stable tree - I've
submitted Ocfs2 patches to stable in the past.
	--Mark

--
Mark Fasheh
