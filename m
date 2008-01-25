From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 25 Jan 2008 11:42:29 -0500
Message-ID: <20080125164229.GD17907@mit.edu>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <479A0F91.2030206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479A0F91.2030206@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 25, 2008 at 10:34:25AM -0600, Eric Sandeen wrote:
> > But it was this concern which is why ext3 never exported freeze
> > functionality to userspace, even though other commercial filesystems
> > do support this.  It wasn't that it wasn't considered, but the concern
> > about whether or not it was sufficiently safe to make available.
> 
> What's the safety concern; that the admin will forget to unfreeze?

That the admin would manage to deadlock him/herself and wedge up the
whole system...

> I'm also not sure I see the point of the timeout in the original patch;
> either you are done snapshotting and ready to unfreeze, or you're not;
> 1, or 2, or 3 seconds doesn't really matter.  When you're done, you're
> done, and you can only unfreeze then.  Shouldn't this be done
> programmatically, and not with some pre-determined timeout?

This is only a guess, but I suspect it was a fail-safe in case the
admin did manage to deadlock him/herself.  

I would think a better approach would be to make the filesystem
unfreeze if the file descriptor that was used to freeze the filesystem
is closed, and then have explicit deadlock detection that kills the
process doing the freeze, at which point the filesystem unlocks and
the system can recover.

					- Ted
