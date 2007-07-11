From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 10 Jul 2007 23:35:29 -0700
Message-ID: <20070710233529.7d8bfe9a.akpm@linux-foundation.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<1184119748.20193.37.camel@localhost.localdomain>
	<20070710221721.23c46edf.akpm@linux-foundation.org>
	<1184123930.20193.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbXGKGft (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 02:35:49 -0400
In-Reply-To: <1184123930.20193.61.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Jul 2007 23:18:50 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> On Tue, 2007-07-10 at 22:17 -0700, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 22:09:08 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> > 
> > > David Chinneer pointed that we need to journal the version number
> > > updates together with the operations that causes the change of the inode
> > > version number, in order to survive server crashes so clients won't see
> > > the counter go backwards.
> > > 
> > > So increment i_version in fs code is probably the place to ensure the
> > > inode version changes are stored to disk. It's seems update the ext4
> > > inode version in every ext4_mark_inode_dirty() is the easiest way.
> > 
> > That still makes us dependent upon _something_ changing the inode.  For
> > overwrites the only something is mtime.
> > 
> > If we don't want to have a peculiar dependency upon s_time_gran=1e9 (and
> > I don't think we do) then I guess we'll need new code in or around
> > file_update_time() to do this.
> 
> do you mean mark inode dirty all the times in file_update_time()? Not
> sure about the overhead for ext3/4.
> 

hm, I hadn't thought about it in any detail.

Maybe something like

--- a/fs/inode.c~a
+++ a/fs/inode.c
@@ -1238,6 +1238,11 @@ void file_update_time(struct file *file)
 		sync_it = 1;
 	}
 
+	if (IS_I_VERSION_64(inode)) {
+		inode_inc_iversion(inode);	/* Takes i_lock on 32-bit */
+		sync_it = 1;
+	}
+
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
 }
_

?
