From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [Ext4 Secure Delete 0/7 v4] Ext4 secure delete
Date: Fri, 7 Oct 2011 09:21:41 -0600
Message-ID: <9097F954-EA60-481E-B05C-5FACDBA2641A@gmail.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-10-07, at 1:10 AM, Allison Henderson <achender@linux.vnet.ibm.com> wrote:
> Sorry for the delay in getting this next version out.
> I had some tasks to take care of, and now I'm picking up my
> secure delete work again. I'm still not quite done yet,
> but a lot has changed and I wanted to update people so that
> we have an idea of where its going.  Currently the patch
> deals with data blocks, meta blocks, directory entries,
> journal blocks, and also provides an option for secure
> deleting with random data instead of just zeros.
> I'm also planning on adding some more patches to
> deal with inodes and also a mount option that turns
> on secure delete by default.  Im still not quite done
> debugging, but Im just sending it out early to get
> some more eyes on it. Feed back appreciated!  :)
> 
> v3->v4
> Added a new file attribute flag EXT4_SECRM_RANDOM_FL
> This flag causes the secure delete operations to over write
> blocks with random data instead of zeros.

Since inode flags are in short supply, and I suspect users that want this want it for all files, this should probably be a superblock flag?

> New function ext4_secure_delete_lblks added to walk
> data blocks and secure delete them before any blocks
> are removed.
> 
> Meta blocks are secure deleted before they are
> released
> 
> New function added to identify holes in ind files.
> Used by ext4_secure_delete_lblks to skip over holes
> during secure delete.
> 
> Added another list in the journal structure to track
> journal blocks so that they can be secure deleted later.
> 
> Added new ext4_secure_delete_jblks that secure deletes
> journal blocks that were used to journal the specified
> logical blocks
> 
> Allison Henderson (7):
>  ext4: Secure Delete: Add new EXT4_SECRM_RANDOM_FL flag
>  ext4: Secure Delete: Add ext4_ind_hole_lookup function
>  ext4: Secure Delete: Add secure delete functions
>  ext4: Secure Delete: Secure delete file data
>  ext4: Secure Delete: Secure delete directory entry
>  ext4: Secure Delete: Secure delete meta data blocks
>  ext4/jbd2: Secure Delete: Secure delete journal blocks
> 
> fs/ext4/ext4.h         |   28 +++-
> fs/ext4/ext4_extents.h |    2 +
> fs/ext4/extents.c      |   21 +++-
> fs/ext4/indirect.c     |    2 +-
> fs/ext4/inode.c        |  391 ++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/mballoc.c      |    8 +
> fs/ext4/namei.c        |   64 +++++++-
> fs/jbd2/commit.c       |    6 +
> fs/jbd2/journal.c      |  112 ++++++++++++++
> include/linux/jbd2.h   |   21 +++
> 10 files changed, 642 insertions(+), 13 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
