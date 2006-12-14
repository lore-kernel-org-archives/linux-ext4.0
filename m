From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Dec 2006 16:04:55 -0700
Message-ID: <20061214230455.GN5937@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <1158171071.6072.10.camel@lade.trondhjem.org> <20061214012428.GA11548@schatzie.adilger.int> <20061214015212.GA30071@fieldses.org> <1166114889.20014.30.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:51851 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbWLNXE5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2006 18:04:57 -0500
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Content-Disposition: inline
In-Reply-To: <1166114889.20014.30.camel@lade.trondhjem.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 14, 2006  11:48 -0500, Trond Myklebust wrote:
> > The only requirement is that it be unique (assuming a file is never
> > modified 2^64 times).  Clients can't compare them except for equality.
> 
> The other requirement is that they be updated in more or less any
> situation where you would normally see a 'ctime' update. In other words
> any time when the file metadata or data changes, and any time when the
> ACL changes.

So, to confirm - if existing ext3 filesystems only had 32 bits for the
change attribute, but ext4 filesystems had 64 bits, would that be OK?
If the change attribute would wrap in rare cases, it would still satisfy
the inequality check, but the sequential update behaviour would be lost
for that one update and the client may unnecessarily flush its cache,
or in extremely rare cases NOT flush its cache (if it was disconnected
for exactly 2^32 updates).

If there is a hard requirement for 64-bit change attributes then this
wouldn't be possible without forcing a reformat and update to ext4
with large inodes.

> Yup. It is used to detect changes made on the NFS server itself
> (possibly by other NFS clients, possibly by local processes on the
> server), so that the client can flush out any stale cached data.

What API do you think would be good for getting the change attribute?
I was thinking using i_version for this would be appropriate, since
that is used for the same function already (internal revalidation of
an inode after a lock was dropped temporarily).  It would need to be
extended to 64 bits in size (if you can convince the rest of the
kernel developers about this) or alternately an export_operations method
and the filesystem stores the 64-bit version in its inode_info?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
