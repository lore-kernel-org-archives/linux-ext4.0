From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
 security/acl
Date: Fri, 18 Apr 2014 09:39:20 -0700
Message-ID: <20140418163920.GB13808@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
 <1397071311-28371-2-git-send-email-bfoster@redhat.com>
 <20140410102421.GA17641@infradead.org>
 <20140410121947.GA14124@bfoster.bfoster>
 <20140410122944.GA6579@infradead.org>
 <20140415175228.GE26404@infradead.org>
 <1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
 <20140416111402.GA32350@infradead.org>
 <359356562.473582.1397669369258.JavaMail.zimbra@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Brian Foster <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <andreas.gruenbacher-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <359356562.473582.1397669369258.JavaMail.zimbra-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 16, 2014 at 07:29:29PM +0200, Andreas Gruenbacher wrote:
> > Btw, I think the man page is wrong - given that the tmpfile is not
> > visible in the namespace it is obviously not created in the directory.
> > The directory passed in is just a handle for the filesystem it should be
> > created in.
> 
> I don't agree.  If the file is created with O_TMPFILE | O_EXCL, it is clear
> that the file will never be linked into the namespace.  Even then, there are
> operations which are affected by the inode permissions and label of the
> anonymous file, and those should still behave reasonably.  In this context,
> I would expect them to behave as if the file was actually created in the
> specified directory, not in the file system root or "nowhere" with no clearly
> defined permissions and security label.

So you want to define the files as being in a directory, but not
actually visible?  That's defintively a new and strange state to be in.

> > Inheriting any ACL on creating an anonymous file seems utterly wrong.
> 
> Why?

Because it has no parent to inherit it from.

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
