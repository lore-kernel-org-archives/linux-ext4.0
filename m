From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: add generic uevent infrastructure
Date: Tue, 19 Nov 2013 12:17:19 +0100
Message-ID: <20131119111719.GA25036@quack.suse.cz>
References: <1384785520-607-1-git-send-email-dmonakhov@openvz.org>
 <20131118162045.GA3268@infradead.org>
 <20131119013621.GH11434@dastard>
 <20131119102501.GA5107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119102501.GA5107@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 19-11-13 02:25:01, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 12:36:21PM +1100, Dave Chinner wrote:
> > I certain agree with that. I'd also like to see ENOSPC notifications
> > as that would obliviate the need for distros like RHEL to ship
> > systemtap scripts to generate such notifications for admins....
> 
> The ENOSPC case would be a natural tag on to Jan's quota notification,
> and I have a vague memory that someone started implementing it or
> at least talked about it.
  Yes, quota netlink interface is technically very easy to extend to also
provide ENOSPC notifications. It's just that the name of generic netlink
family is 'VFS_DQUOT' so ENOSPC notifications do not fit very well with
that name but it isn't too bad either.

> > > Also Jan Kara has done quota netlink notifications a while ago, which
> > > fit into the same sort of niche.
> > 
> > The question I'm asking is whether we really want a new interface
> > for these events? Shouldn't we really try to use an existing
> > filesystem event interface for generating these events
> 
> Good quetion, and the quota netlink notifications would be the natural
> place to tag on at least some of this.
> 
> > (e.g.
> > fanotify) rather than adding yet another disjoint filesystem event
> > interface to the kernel?
> 
> It needs to be a per-fs interface, and as Dmitry pointed out fanotify
> is a per-file one.
  I agree fanotify is really a bad fit.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
