From: Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 19:59:15 +0000
Message-ID: <1389124784.23310.15.camel@ret.masoncoding.com>
References: <20140107025855.GA9229@birch.djwong.org>
	 <20140107124831.GD16640@quack.suse.cz>
	 <20140107154935.GA17609@infradead.org> <20140107170430.GA2822@thunk.org>
	 <20140107194356.GC9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"miklos@szeredi.hu" <miklos@szeredi.hu>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"rlb@defaultvalue.org" <rlb@defaultvalue.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aurelien@aurel32.net" <aurelien@aurel32.net>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140107194356.GC9229@birch.djwong.org>
Content-Language: en-US
Content-ID: <58FB75862F7EA845BB0CC61650913C29@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2014-01-07 at 11:43 -0800, Darrick J. Wong wrote:
+AD4- On Tue, Jan 07, 2014 at 12:04:30PM -0500, Theodore Ts'o wrote:
+AD4- +AD4- On Tue, Jan 07, 2014 at 07:49:35AM -0800, Christoph Hellwig wrote:
+AD4- +AD4- +AD4- On Tue, Jan 07, 2014 at 01:48:31PM +-0100, Jan Kara wrote:
+AD4- +AD4- +AD4- +AD4-   I have to say I'm not thrilled by the idea of juggling strings in
+AD4- +AD4- +AD4- +AD4- userspace and in kernel to set a flag for an inode...
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Nevermind the massive amounts of code that sit in the filesystem.
+AD4- +AD4- 
+AD4- +AD4- The reason for this patch was to address what Dave Chinner has called
+AD4- +AD4- +ACI-a shitty interface+ACIAWw-1+AF0-.  Using bitfields that need to be coordinated
+AD4- +AD4- across file systems, when sometimes a bit assignment is validly a fs
+AD4- +AD4- specific thing, and then later becomes something that gets shared
+AD4- +AD4- across file systems.
+AD4- +AD4- 
+AD4- +AD4- +AFs-1+AF0- http://thread.gmane.org/gmane.linux.file-systems/80164/focus+AD0-80396
+AD4- +AD4- 
+AD4- +AD4- If we don't go about it this way, there are alternatives: we could
+AD4- +AD4- create new ioctls (or a new syscall) as we start running out of bits
+AD4- +AD4- used by FS+AF8-IOC+AF8AWw-GS+AF0-ETFLAGS.  We can create new ioctls for bits which
+AD4- +AD4- are intended for fs-specific flags, which then later get promoted to
+AD4- +AD4- the new syscall when some functionality starts to get shared accross
+AD4- +AD4- other file systems (probably with a different bit assignment).  This
+AD4- +AD4- is certainly less code, but it does mean more complexity outside of
+AD4- +AD4- the code when we try to coordinate new functionality across file
+AD4- +AD4- systems.
+AD4- 
+AD4- I had thought of indexed inode flags as an alternative to the xattr/string
+AD4- parsing thing.  Feature flags make their first appearance as part of a per-FS
+AD4- flag-space and are migrated to the common flag-space when there is demand.
+AD4- It would also avoid the need for each fs to create its own flag ioctl.
+AD4- 
+AD4- On the other hand, someone suggested I try remaking IOC+AF8AWw-GS+AF0-ETFLAG as an xattr,
+AD4- so off I went. :)
+AD4- 

At least in btrfs xattrs are more expensive than something right in the
inode.  We can cache it when we load the inode (it'll be right next to
the inode most of the time) but for performance critical things I do
like the good old fashioned flags.

It's also possible to turn xattrs off, so we have to deal with
filesystems that are mounted with them off and then back on again.  I
can't think of huge problems from that right now, just something to be
aware of.

-chris
