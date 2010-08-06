From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Fri, 6 Aug 2010 13:12:23 -0400
Message-ID: <20100806171223.GB16599@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804230421.GC29353@shell> <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 05, 2010 at 01:13:55PM +0200, Miklos Szeredi wrote:
> On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > > Another idea is to use an internal inode and make all fallthroughs be
> > > hard links to that.
> > > 
> > > I think the same would work for whiteouts as well.  I don't like the
> > > fact that whiteouts are invisible even when not mounted as part of a
> > > union.
> > 
> > I don't know if this helps, but I just wrote support for removing ext2
> > whiteouts and fallthrus using tune2fs and e2fsck.  I think this does
> > what people want from a "visible" whiteout feature without adding more
> > complexity to the VFS.  It also takes away all consideration of race
> > conditions and dentry conversion that happens with online removal of
> > whiteouts and fallthrus.
> > 
> > What are your thoughts on what a visible whiteout/fallthru would look
> > like?
> 
> Best would be if it didn't need any modification to filesystems.  All
> this having to upgrade util-linux, e2fsprogs, having incompatible
> filesystem features is a pain for users (just been through that).
> 
> What we already have in most filesystems:
> 
>  - extended attributes, e.g. use the system.union.* namespace and
>    denote whiteouts and falltroughs with such an attribute
> 
>  - hard links to make sure a separate inode is not necessary for each
>    whiteout/fallthrough entry
> 
>  - some way for the user to easily identify such files when not
>    mounted as part of a union e.g. make it a symlink pointing to
>    "(deleted)" or whatever
> 
> Later the extended attributes can also be used for other things like
> e.g. chmod()/chown() only copying up metadata, not data, and
> indicating that data is still found on the lower layers.

Just a quick note to say that my explicit design was to do as much as
possible in the VFS, except when adding a little support to the
low-level fs would make it significantly faster, simpler, and more
correct.  I think for union mounts to perform moderately well, and to
avoid namespace problems, we can't build it 100% out of existing file
system parts like xattrs.  However, I could be wrong and I will
definitely give any other implementation serious consideration.

-VAL
