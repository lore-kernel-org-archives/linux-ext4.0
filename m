From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 00/11]  New ACL format for better NFSv4 acl interoperability
Date: Tue, 12 Oct 2010 12:47:38 +0530
Message-ID: <m3bp6zswvh.fsf@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20101012002409.GH16442@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56207 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab0JLHRs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Oct 2010 03:17:48 -0400
In-Reply-To: <20101012002409.GH16442@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 Oct 2010 20:24:09 -0400, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> On Fri, Sep 24, 2010 at 06:18:03PM +0530, Aneesh Kumar K.V wrote:
> > 
> > Hi,
> > 
> > The following set of patches implements VFS changes needed to implement
> > a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
> > extended by file masks to fit into the standard POSIX file permission model.
> > They are designed to work seamlessly locally as well as across the NFSv4 and
> > CIFS/SMB2 network file system protocols.
> > 
> > The patch set consists of four parts:
> > 
> > The first set of patches, posted as a follow up, contains VFS changes needed
> > to implement the Rich ACL model. The second set [1] contains the Rich ACL model
> > and Ext4 implementation. The third set [2] contains mapping of Rich ACL to
> > NFSv4 ACL (how to apply file mask to access mask) and implementation of
> > Richacl ACL for NFS server and client.
> 
> That's the part I'd like to review carefully and haven't yet.
> 
> > The fourth set [3] contains POSIX ACL
> > to Rich ACL mapping and its ext4 usage.
> 
> The one thing I remember not liking before was a flag that told the user
> whether a given ACL was originally mapped from POSIX or not.  Is that
> still there?

We still have that. But we can resolve that once we decide on how to
migrate an existing file system containing posix acl to richacl. Most of
those patches will need to be updated based on the feedback from
different local file system maintainers. That is why those patches are
pushed towards the end and is  part of last set.

What we need in the first step is to get VFS changes reviewed.Once we
agree on the VFS changes done, then we can start looking at the changes
upto NFS richacl nfs support. When get that merged then we can start
having discussion on how local file system maintainers want to migrate
the existing file system with posixacl to richacl.

> 
> Overall I'm for doing this: I don't like NFSv4/Windows ACLs more than
> anyone else, but they're too useful to ignore, and the mapping that
> Samba and the NFSv4 server try to do is painful for users.
> 


-aneesh
