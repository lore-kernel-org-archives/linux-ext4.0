From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch 2/2] i_version update - ext4 part
Date: Wed, 30 May 2007 16:48:44 -0700
Message-ID: <1180568925.3794.44.camel@dyn9047017103.beaverton.ibm.com>
References: <46570E16.5040006@bull.net>
	 <1180467854.4204.15.camel@localhost.localdomain>
	 <20070529225817.GE5181@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jean-noel.cordenner@bull.net, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070529225817.GE5181@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-29 at 16:58 -0600, Andreas Dilger wrote:
> On May 29, 2007  12:44 -0700, Mingming Cao wrote:
> > I am a little bit confused about the two patches. 
> > 
> > It appears in the ext4_expand_inode_extra_isize patch by Kalpak, there a
> > new 64 bit i_fs_version field is added to ext4 inode structure for inode
> > versioning support. read/store of this counter are properly handled, but
> > missing the inode versioning counter update.
> 
> For the Lustre use of the inode version we don't care about the VFS changes
> to i_version.  In fact - we want to be able to control the changes to
> inode version ourselves so that e.g. file defragmenting or atime updates
> don't change the inode version, and that recovery can restore the version
> to a known state along with the rest of the metadata.
> 
It's a pity that VFS i_version can't serve Lustre need completely. :(

If the unnecessary inode version update is a concern, then, with current
implementation (i_version being updated in ext4_mark_inode_dirty()-
>ext4_mark_iloc_dirty()), the i_version can be increased multiple times
during one write() operation (unlike ctime update). I know doing the
update in ext4_mark_inode_dirty() (rather than update inode version on
every mtime/ctime update) clearly simplified the code changes. So I am
not sure if the increased update is a concern or not.

In any case, does the VFS inode version get update when atime updates?

> That said, since Lustre isn't in the kernel and we patch our version of
> ext3 anyways it doesn't really matter what is done for NFS.  We will just
> patch in our own behaviour if the final ext4 code isn't suitable in all
> of the details.  Having 99% of the code the same at least makes this a
> lot less work.
>
> > But later in the second patch by Jean Noel, he re-used the VFS inode-
> > >i_version for ext4 inode versioning, the counter is being updated every
> > time the file is being changed. 
> 
> I don't know what the NFS requirements for the version are.  There may
> also be some complaints from others if the i_version is 64 bits because
> this contributes to generic inode growth and isn't used for other
> filesystems.
> 
That should benefit for other filesystems, as I thought this NFS
requirements apply to all filesystems. 

> > To me, i_fs_version and inode_version are the same thing, right?
> > Shouldn't we choose one(I assume inode i_version?), and combine these
> > two patch together? How about split the inode versioning part from the
> > ext4_expand_inode_extra_isize patch(it does multiple things, and
> > i_versioning doesn't longs there) and put it together with the rest of
> > i_version update patches?
> 
> I don't have an objection to that, but I don't think it is required.
> 
> > BTW, how could NFS/user space to access the inode version counter?
> 
> If the Bull patch uses i_version then knfsd can just access it directly.
> I don't think there is any API to access it from userspace.  One option
> is to add a virtual EA like user.inode_version and have the kernel fill
> this in from i_version.
> 
> Lustre will manipulate the ei->i_fs_version directly.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

