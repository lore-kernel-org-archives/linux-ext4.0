From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Fri, 1 Aug 2014 14:40:15 +0200
Message-ID: <20140801124015.GA5431@quack.suse.cz>
References: <CAPTn0cBJMx=s5YhKPEVgGa4xvxP1H9L=gJaK1iP4dkooHzr_FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaHAMkR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 08:40:17 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cBJMx=s5YhKPEVgGa4xvxP1H9L=gJaK1iP4dkooHzr_FA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 01-08-14 09:05:23, Li Xi wrote:
> The following patches propose an implementation of project support
> for ext4. A project is an aggregate of unrelated inodes which might
> scatter in different directories. Inodes belongs to a project
> possesses a same identification i.e. 'project ID', just like every
> inode has its user/group indentification. The following patches adds
> project quota as supplement to the former uer/group quota types.
> This project ID of an inode is iherited from its parent direcotry
> and saved as an internal field of ext4 inode.
> 
> This is not the first existed attepmtion to add project quta support
> for ext4. Patches of subtree quota support which was posted by Dmity
> Monakhov in 2012 (http://lwn.net/Articles/506064/) implemented the
> similar feature in a different way. Rather than saving the project
> (or subtree) ID as an internal inode field, those patches manages
> the ID as extented attributes.
  Thanks for reviving the feature. I think it is a useful one.  I had a
brief look into the series and here are some highlevel comments:

1) It should have been also posted to linux-fsdevel@vger.kernel.org, Al Viro
<viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org> because
you are changing core VFS inode and infrastructure as well. For quota
changes you should have also CCed me as a quota maintainer.

2) I'm not convinced we actually want project ID in the core inode - so far
only XFS has this. For everyone else it's just extra bloat so we could just
put it in ext4_inode_info. Granted we'd need to somewhat change quota
interface so that it sees all the ids (uid, gid, projid) but they are
really needed in two places - dquot_initalize() and dquot_transfer() and
creating variants of these functions that just take an array of ids and use
them in ext4 is simple enough.

3) I see no way how to get / set project ID from userspace. Did I miss
something?

4) The ext4 change is changing on-disk format. You definitely need a
feature flag for that so that kernels that don't understand project quotas
don't corrupt the filesystem. Also you need a support for this in
e2fsprogs.

5) You make the feature configurable both in quota code and ext4. I don't
think the footprint of the feature warrants that.
 
> We rebased both patch sets onto the same kernel version and run
> benchmakrs respectively to comparing the peformance difference.
> It is worth noting that patches from Lai Siyao and Niu Yawei
> (quota: remove dqptr_sem,
> http://article.gmane.org/gmane.comp.file-systems.ext4/44341/)
> improve the performance of quota enforcement significantly, which
> can be seen clearly from following results.
  I plan to send that to Linus in this merge window BTW.

> It is obvious that extended attribute implementation has performance
> impact when creating files. That is why we choose to push the patches
> which use internal inode field to save project ID.

							Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
