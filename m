From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 10 Jul 2007 20:19:16 -0400
Message-ID: <1184113156.20193.13.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20070710182237.e2f88bf3.akpm@linux-foundation.org>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 18:22 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 18:09:40 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> > > On Sun, 01 Jul 2007 03:37:04 -0400
> > > Mingming Cao <cmm@us.ibm.com> wrote:
> > > 
> > > > This patch converts the 32-bit i_version in the generic inode to a 64-bit
> > > > i_version field.
> > > > 
> > > 
> > > That's obvious from the patch.  But what was the reason for making this
> > > (unrelated to ext4) change?
> > > 
> > 
> > The need is came from NFSv4
> > 
> > On Fri, 2007-05-25 at 18:25 +0200, Jean noel Cordenner wrote: 
> > > Hi,
> > > 
> > > This is an update of the i_version patch.
> > > The i_version field is a 64bit counter that is set on every inode
> > > creation and that is incremented every time the inode data is modified
> > > (similarly to the "ctime" time-stamp).
> > > The aim is to fulfill a NFSv4 requirement for rfc3530:
> > > "5.5.  Mandatory Attributes - Definitions
> > > Name		#	DataType   Access   Description
> > > ___________________________________________________________________
> > > change		3	uint64       READ     A value created by the
> > > 		server that the client can use to determine if file
> > > 		data, directory contents or attributes of the object
> > > 		have been modified.  The servermay return the object's
> > > 		time_metadata attribute for this attribute's value but
> > > 		only if the filesystem object can not be updated more
> > > 		frequently than the resolution of time_metadata.
> > > "
> > > 
> > 
> > > Please update the changelog for this.
> > > 
> > 
> > Is above description clear to you?
> > 
> 
> Yes, thanks.  It doesn't actually tell us why we want to implement
> this attribute and it doesn't tell us what the implications of failing
> to do so are, but I guess we can take that on trust from the NFS guys.
> 
> But I suspect the ext4 implementation doesn't actually do this.  afaict we
> won't update i_version for file overwrites (especially if s_time_gran can
> indeed be 1,000,000,000) and of course for MAP_SHARED modifications.  What
> would be the implications of this?
> 

In the case of overwrite (file date updated), I assume the ctime/mtime
is being updated and the inode is being dirtied, so the version number
is being updated.

 vfs_write()->..
        ->__generic_file_aio_write_nolock()
                ->file_update_time()
                        ->mark_inode_dirty_sync()
                        ->__mark_inode_dirty(I_DIRTY_SYNC)
                                ->ext4_dirty_inode()
                                        ->ext4_mark_inode_dirty()

> And how does the NFS server know that the filesystem implements i_version? 
> Will a zero-value of i_version have special significance, telling the
> server to not send this attribute, perhaps?

Bruce raised up this question a few days back when he reviewed this
patch, I think the solution is add a superblock flag for fs support
inode versioning, probably at VFS layer?

Mingming
