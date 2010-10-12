From: "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH -V4 00/11]  New ACL format for better NFSv4 acl
 interoperability
Date: Tue, 12 Oct 2010 11:35:07 -0400
Message-ID: <20101012153507.GC12752@fieldses.org>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20101012002409.GH16442@fieldses.org>
 <m3bp6zswvh.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m3bp6zswvh.fsf@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 12, 2010 at 12:47:38PM +0530, Aneesh Kumar K. V wrote:
> On Mon, 11 Oct 2010 20:24:09 -0400, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> > The one thing I remember not liking before was a flag that told the user
> > whether a given ACL was originally mapped from POSIX or not.  Is that
> > still there?
> 
> We still have that. But we can resolve that once we decide on how to
> migrate an existing file system containing posix acl to richacl. Most of
> those patches will need to be updated based on the feedback from
> different local file system maintainers. That is why those patches are
> pushed towards the end and is  part of last set.
> 
> What we need in the first step is to get VFS changes reviewed.Once we
> agree on the VFS changes done, then we can start looking at the changes
> upto NFS richacl nfs support. When get that merged then we can start
> having discussion on how local file system maintainers want to migrate
> the existing file system with posixacl to richacl.

OK.  So, personally: I'm resigned to the idea that we want support for
this ACL model.  The vfs changes look OK to me (and wouldn't be changed
by any comments I'd have on the more richacl-specific patches to
follow).  So that's an ACK from me on the first set of these patches,
assuming it's OK with people to merge these things one step at a time.

--b.
