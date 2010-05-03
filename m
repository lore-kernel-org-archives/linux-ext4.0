From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Mon, 3 May 2010 13:19:44 +0530
Message-ID: <201005031319.44538.knikanth@suse.de>
References: <201004281854.49730.knikanth@suse.de> <201005030953.45157.knikanth@suse.de> <20100503065945.GA13756@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100503065945.GA13756@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 03 May 2010 12:29:45 Amit K. Arora wrote:
> On Mon, May 03, 2010 at 09:53:44AM +0530, Nikanth Karthikesan wrote:
> > On Saturday 01 May 2010 12:34:26 Amit K. Arora wrote:
> > > On Fri, Apr 30, 2010 at 02:33:19PM -0700, Andrew Morton wrote:
> > > > Also, there doesn't seem to be much point in doing
> > > >
> > > > 	mutex_lock(i_mutex);
> > > > 	if (some_condition)
> > > > 		bale out
> > > > 	mutex_unlock(i_mutex);
> > > >
> > > > 	<stuff>
> > > >
> > > > because `some_condition' can now become true before or during the
> > > > execution of `stuff'.
> > > >
> > > > IOW, it's racy.
> >
> > oh, yes. :(
> >
> > > Agreed. How about doing this check in the filesystem specific fallocate
> > > inode routines instead ? For example, in ext4 we could do :
> >
> > I guess, calling the filesystem specific fallocate with the lock held
> > would create lock ordering problems? If so, this might be the only way.
> > But it would be better to document at the call site, that the callee
> > should check for RLIMIT_FSIZE.
> 
> Hmm.. I never said to call the filesystem specific fallocate with
> i_mutex held. What I suggested was that each filesystem at some point
> anyhow takes the i_mutex to preallocate. Thats where the check should
> be, to avoid the race. This is what the example patch below does.
> 

Yes, you never said that. But I just wondered whether that would be have 
problems and doing the check in filesystem specific fallocate is the only 
solution. :)

Thanks
Nikanth
