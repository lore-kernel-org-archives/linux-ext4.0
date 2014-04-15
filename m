From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
 security/acl
Date: Tue, 15 Apr 2014 10:52:28 -0700
Message-ID: <20140415175228.GE26404@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
 <1397071311-28371-2-git-send-email-bfoster@redhat.com>
 <20140410102421.GA17641@infradead.org>
 <20140410121947.GA14124@bfoster.bfoster>
 <20140410122944.GA6579@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Foster <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140410122944.GA6579-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

So any opinions from other fs / security people on how O_TMPFILE files
should behave for ACL inheritance / labeling?

On Thu, Apr 10, 2014 at 05:29:44AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 10, 2014 at 08:19:48AM -0400, Brian Foster wrote:
> > Are you saying it doesn't have to initialize security or the default
> > acl, or both?
> 
> The ACLs for sure.  LSM do run-time access decisions, so they will
> probably rely on the security data being initialized.  Given that
> O_TMPFILE files aren't publicly available I'm not sure there's a point
> in them doing that, though.
> 
> LSMs are also affected by the lack of a proper parent I'll discuss for
> ACLs below.
> 
> > The intent here was to have the case covered where the inode happens to
> > be linked back into the namespace since we don't do this work in the
> > link path.
> 
> That's an interesting one.  O_TMFILE files don't have a real parent
> to inherit ACLs from, the pathname passed in just needs to point to
> a directory to find the filesystem to create the tmpfile in.  On
> the other hand it seem like the extN implementations do inherity the
> ACL in this case.
> 
> The link into the namespace is irrelavant here as ACL inheritance only
> happens on initial create, not at link time.
> 
> I also think we'll absolutely need a test case for ACLs+tmpfile to
> make sure all filesystems handle it the same way.
> 
> > The bulk of the refactoring was with the idea that the inode setup for
> > the tmpfile case is generally equivalent for the traditional create
> > case. The original version was posted here:
> > 
> > http://oss.sgi.com/archives/xfs/2014-04/msg00149.html
> > 
> > ... and it just fixes the deadlock and adds the security initialization.
> > I suppose I could still break that out into multiple patches, but that
> > aside, is that behavior preferred?
> 
> I think just fixing the deadlock and initializing the security is enough
> for the first pass.  If you want to do the refactoring on top send it as
> a second series on top of the actual fixes.
> 
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
