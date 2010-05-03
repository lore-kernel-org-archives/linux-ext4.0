From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE
	using fallocate
Date: Mon, 3 May 2010 12:29:45 +0530
Message-ID: <20100503065945.GA13756@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org> <20100501070426.GA9562@amitarora.in.ibm.com> <201005030953.45157.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201005030953.45157.knikanth@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 03, 2010 at 09:53:44AM +0530, Nikanth Karthikesan wrote:
> On Saturday 01 May 2010 12:34:26 Amit K. Arora wrote:
> > On Fri, Apr 30, 2010 at 02:33:19PM -0700, Andrew Morton wrote:
> > > Also, there doesn't seem to be much point in doing
> > >
> > > 	mutex_lock(i_mutex);
> > > 	if (some_condition)
> > > 		bale out
> > > 	mutex_unlock(i_mutex);
> > >
> > > 	<stuff>
> > >
> > > because `some_condition' can now become true before or during the
> > > execution of `stuff'.
> > >
> > > IOW, it's racy.
> 
> oh, yes. :(
> 
> > Agreed. How about doing this check in the filesystem specific fallocate
> > inode routines instead ? For example, in ext4 we could do :
> 
> I guess, calling the filesystem specific fallocate with the lock held would 
> create lock ordering problems? If so, this might be the only way. But it would 
> be better to document at the call site, that the callee should check for 
> RLIMIT_FSIZE.

Hmm.. I never said to call the filesystem specific fallocate with
i_mutex held. What I suggested was that each filesystem at some point
anyhow takes the i_mutex to preallocate. Thats where the check should
be, to avoid the race. This is what the example patch below does.

--
Regards,
Amit Arora

> Thanks
> Nikanth
> 
> > diff -Nuarp linux-2.6.org/fs/ext4/extents.c linux-2.6.new/fs/ext4/extents.c
> > --- linux-2.6.org/fs/ext4/extents.c	2010-05-01 12:16:07.000000000 +0530
> > +++ linux-2.6.new/fs/ext4/extents.c	2010-05-01 12:17:37.000000000 +0530
> > @@ -3672,6 +3672,11 @@ long ext4_fallocate(struct inode *inode,
> >  	 */
> >  	credits = ext4_chunk_trans_blocks(inode, max_blocks);
> >  	mutex_lock(&inode->i_mutex);
> > +	ret = inode_newsize_ok(inode, (offset + len));
> > +	if (ret) {
> > +		mutex_unlock(&inode->i_mutex);
> > +		return ret;
> > +	}
> >  retry:
> >  	while (ret >= 0 && ret < max_blocks) {
> >  		block = block + ret;
> > 
> > 
> > Similarly for ocfs2, btrfs and xfs..
> > 
> > --
> > Regards,
> > Amit Arora
> > 
