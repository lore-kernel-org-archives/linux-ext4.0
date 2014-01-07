From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 11:43:56 -0800
Message-ID: <20140107194356.GC9229@birch.djwong.org>
References: <20140107025855.GA9229@birch.djwong.org>
 <20140107124831.GD16640@quack.suse.cz>
 <20140107154935.GA17609@infradead.org>
 <20140107170430.GA2822@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140107170430.GA2822@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 07, 2014 at 12:04:30PM -0500, Theodore Ts'o wrote:
> On Tue, Jan 07, 2014 at 07:49:35AM -0800, Christoph Hellwig wrote:
> > On Tue, Jan 07, 2014 at 01:48:31PM +0100, Jan Kara wrote:
> > >   I have to say I'm not thrilled by the idea of juggling strings in
> > > userspace and in kernel to set a flag for an inode...
> > 
> > Nevermind the massive amounts of code that sit in the filesystem.
> 
> The reason for this patch was to address what Dave Chinner has called
> "a shitty interface"[1].  Using bitfields that need to be coordinated
> across file systems, when sometimes a bit assignment is validly a fs
> specific thing, and then later becomes something that gets shared
> across file systems.
> 
> [1] http://thread.gmane.org/gmane.linux.file-systems/80164/focus=80396
> 
> If we don't go about it this way, there are alternatives: we could
> create new ioctls (or a new syscall) as we start running out of bits
> used by FS_IOC_[GS]ETFLAGS.  We can create new ioctls for bits which
> are intended for fs-specific flags, which then later get promoted to
> the new syscall when some functionality starts to get shared accross
> other file systems (probably with a different bit assignment).  This
> is certainly less code, but it does mean more complexity outside of
> the code when we try to coordinate new functionality across file
> systems.

I had thought of indexed inode flags as an alternative to the xattr/string
parsing thing.  Feature flags make their first appearance as part of a per-FS
flag-space and are migrated to the common flag-space when there is demand.
It would also avoid the need for each fs to create its own flag ioctl.

On the other hand, someone suggested I try remaking IOC_[GS]ETFLAG as an xattr,
so off I went. :)

#define FS_IOC_FLAGS_COMMON	0
#define FS_IOC_FLAGS_COMMON2	1
#define FS_IOC_FLAGS_EXT4	0xEF53

struct inode_flag_ioctl {
	u32 flag;
	u32 value;	/* or u64? */
};
#define FS_IOC_GETFLAGS2 _IOR('f', 12, struct inode_flag_ioctl);
#define FS_IOC_SETFLAGS2 _IOW('f', 13, struct inode_flag_ioctl);

foo() {
	struct inode_flag_ioctl if;

	if.flag = FS_IOC_FLAGS_COMMON;
	ioctl(fd, FS_IOC_GETFLAGS2, &if);
	printf("%d\n", if.value);

	if.flag = FS_IOC_FLAGS_EXT4;
	if.value = EXT5_BONGHITS_FL | EXT4_EA_INODE_FL;
	ioctl(fd, FS_IOC_SETFLAGS2, &if);
}

> Personally, I don't mind dealing with codepoint assignments, but my
> impression is that this is a minority viewpoint.  Al and Linus have
> historically hated bitfields, and Al in the past has spoken favorably
> of Plan 9's approach of using strings for the system interface.

I prefer strings too, but I suppose one pays for the complexity.  Given that
all the flags so far seem to have been booleans, this could be good enough.

> So while I have a preference towards using bitfields, as opposed to
> using the xattr approach, what I'd really like is that we make a
> decision, one way or another, about what's the best way to move
> forward.

Agreed.

--D
> 
>    	    	     	      	      	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
