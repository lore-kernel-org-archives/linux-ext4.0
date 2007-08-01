From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 2/4] e2fsprogs: Add undoe2fs
Date: Wed, 1 Aug 2007 03:27:43 -0500
Message-ID: <20070801082743.GS5469@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <20070801060211.GO5469@schatzie.adilger.int> <46B02539.5020505@linux.vnet.ibm.com> <20070801071032.GQ5469@schatzie.adilger.int> <46B03BBE.1060309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48210 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761052AbXHAI2B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 04:28:01 -0400
Content-Disposition: inline
In-Reply-To: <46B03BBE.1060309@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  13:22 +0530, Aneesh Kumar K.V wrote:
> >>Can you let me know a use case where this will fail.
> >
> >- modify filesystem with undo manager (e.g. inode resize)
> >- mount filesystem, make changes, unmount
> >- run undoe2fs to overwrite filesystem, corrupting it
> 
> But that won't corrupt it. It will bring the file system back to
> the state before inode resize.

No, that isn't correct.  The changes done to the filesystem while
mounted will not be recorded in the undo file.  If the undo file
can be replayed over the modified filesystem then only the blocks
in the undo file will be restored, but none of the other blocks
that were modified while the filesystem was mounted.

> I understand that we may want to have
> 
> a) Don't replay if file system is mounted
> b) Don't replay if UUID doesn't match
> 
> But i guess we should allow a replay if file system got changed afterwards.
> Ofcourse the changes will no longer be available after the replay.

No this shouldn't be allowed, except in "--force" mode (which would be
needed after mke2fs because the UUID and s_mtime would change).  For
cases like e2fsck the undo might be helpful.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
