From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] ext3 freeze feature
Date: Sat, 2 Feb 2008 13:52:07 +0000
Message-ID: <20080202135207.GA4456@ucw.cz>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <479A0F91.2030206@redhat.com> <20080125164229.GD17907@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080125164229.GD17907@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 2008-01-25 11:42:29, Theodore Tso wrote:
> On Fri, Jan 25, 2008 at 10:34:25AM -0600, Eric Sandeen wrote:
> > > But it was this concern which is why ext3 never exported freeze
> > > functionality to userspace, even though other commercial filesystems
> > > do support this.  It wasn't that it wasn't considered, but the concern
> > > about whether or not it was sufficiently safe to make available.
> > 
> > What's the safety concern; that the admin will forget to unfreeze?
> 
> That the admin would manage to deadlock him/herself and wedge up the
> whole system...
> 
> > I'm also not sure I see the point of the timeout in the original patch;
> > either you are done snapshotting and ready to unfreeze, or you're not;
> > 1, or 2, or 3 seconds doesn't really matter.  When you're done, you're
> > done, and you can only unfreeze then.  Shouldn't this be done
> > programmatically, and not with some pre-determined timeout?
> 
> This is only a guess, but I suspect it was a fail-safe in case the
> admin did manage to deadlock him/herself.  
> 
> I would think a better approach would be to make the filesystem
> unfreeze if the file descriptor that was used to freeze the filesystem
> is closed, and then have explicit deadlock detection that kills the
> process doing the freeze, at which point the filesystem unlocks and
> the system can recover.

Hmm, not sure that works.

I have shell I used to freeze the ext3. Then it is pushed out by dirty
data waiting to be written to that ext3. Deadlock, with file
descriptor still open, and very hard to detect.

Ok, OOM killer will eventually hit the shell, close the fd and
unfreeze, but that is probably not what you want.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
