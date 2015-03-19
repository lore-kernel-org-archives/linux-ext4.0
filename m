From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC v2 0/6] ext4: yet another project quota
Date: Thu, 19 Mar 2015 10:16:39 +0100
Message-ID: <20150319091639.GD28368@quack.suse.cz>
References: <20150310171133.23081.49616.stgit@buzz>
 <20150316165228.GT4934@quack.suse.cz>
 <CALYGNiOS8gmxA+TLNX+zOuGt3mXEZ4i-mTt2hpN-Rh4VGTkjuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALYGNiOS8gmxA+TLNX+zOuGt3mXEZ4i-mTt2hpN-Rh4VGTkjuQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 17-03-15 08:40:19, Konstantin Khlebnikov wrote:
> On Mon, Mar 16, 2015 at 7:52 PM, Jan Kara <jack@suse.cz> wrote:
> >> Why new ioctls?
> >> ---------------
> >>
> >> XFS has it's own interface for that: XFS_IOC_FSGETXATTR / XFS_IOC_FSSETXATTR.
> >> But it has several flaws and doesn't fit for a role of generic interface.
> >>
> >> It contains a lot of xfs-specific flags and racy by design: set operation
> >> commits all fields at once thus it's used in sequence get-change-set without
> >> any lock, Concurrent updates from user space will collide.
> 
> >   Sure but that's the case for generic GETFLAGS / SETFLAGS interface as
> > well.
> 
> In this case we care only about project id. We can make interface clear,
> non-racy and do it in just one syscall instead of two.
> 
> >
> >> Also xfs has flag XFS_XFLAG_PROJINHERIT which tells should new files inherit
> >> project id from parent directory or not. This flag is barely useful and only
> >> makes everything complicated. Even tools in xfsprogs don't use it: they always
> >> set it together with project id and clears when set project id back to zero.
> >   I think this is about balance - adding the support for the PROJINHERIT flag
> > costs us close to nothing and we get a compatibility with XFS. So even though
> > the usefulness of that flag is doubtful, I think the additional
> > compatibility is worth it.
> 
> There're only few free bits left. This bit gives nothing, xfsprogs can change it
> but project quota management doesn't uses it. It gives nothing but complication.
> 
> Also this bit makes difference only for accounting directories itself
> and it's internal structures. This is pretty fs-specific thing.
> 
> >
> >> And the main reason: this compatibility gives nothing. The only user of xfs
> >> ioctl which I've found is the xfsprogs. And these tools check filesystem name
> >> and don't work anywhere except 'xfs'.
> >   The fact that you didn't find any other user doesn't mean there isn't
> > any. And historically if we though "nobody could be relying on this", we
> > were sometimes proven wrong - a few years later when it was *much* more
> > painful to make things compatible.
> >
> > Here we speak about new feature for the filesystem so compatibility
> > requirements aren't that strong but still I find the case that the same
> > ioctl will just work on ext4 as it does on xfs more appealing than creating
> > a new simpler generic ioctl. That way userspace doesn't have to care on
> > which filesystem it is working or whether the current kernel already
> > supports the new ioctl for XFS. So please use the XFS interface is Li Xi
> > does in his patches.
> 
> Please consider this as _new_ feature which has compatible behaviour
> from user's point of view. That's perfect time to fix its birth defects and
> redesign behavior to satisfy expectations of new users. I do not care
> about migration from xfs to ext4, that's not my case. I do not care about
> mythical closed source software which might use this interface.
> 
> As I already said ioctl compatibility gives nothing but legacy problems.
> Unexpected apperance of partial compatibility might be a nightmare.
> And I've seen a lot when I worked with mixed containerized evironments.
> it emerges untested and unexpected combinations of old and new software.
> But, of course not in this case because nobody uses this interface except
> xfsprogs. And as I said without update it works only with XFS.
> 
> Also that's ioctl is so poorly designed for generic usage so resulting code
> looks like a shit. I just cannot add this into the kernel without any
> good reason.
> 
> I've implemented interface and behaviour xfs-compatible enough to add
> support of that into xfsprogs/xfstests in few lines. That's my next step
> after polishing support in quota-tools.
  Well, you are certainly free to write the feature any way you like. My
experience tells me that writing code compatible between filesystems pays
off even though the code isn't elegant. Ultimately, it's upto Ted as an
ext4 maintainer to decide which approach to take.

For now I've merged Li Xi's first patch which enables project quotas in VFS
quota core and that's independent of this decision.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
