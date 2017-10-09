From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2/super: Fix a possible sleep-in-atomic bug in
 parse_options
Date: Mon, 9 Oct 2017 15:32:51 +0200
Message-ID: <20171009133251.GN17917@quack2.suse.cz>
References: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
 <CA+55aFw9UB1ZKMk-JgLm=xBRST-9JaWv4unFtE3fsygjeVxEjg@mail.gmail.com>
 <20171007020217.GN21978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jia-Ju Bai <baijiaju1990@163.com>, Jan Kara <jack@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, james.smart@broadcom.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171007020217.GN21978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 07-10-17 03:02:17, Al Viro wrote:
> On Fri, Oct 06, 2017 at 06:37:11PM -0700, Linus Torvalds wrote:
> > On Fri, Oct 6, 2017 at 6:20 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
> > >
> > > To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
> > > This bug is found by my static analysis tool and my code review.
> > 
> > I'm not saying your patch is wrong, but it's a shame that we do that
> > extra allocation in match_number() and match_u64int(), and that we
> > don't have anything that is just size-limited.
> > 
> > And there really isn't anything saying that we shouldn't do the same
> > silly thing to match_u64int(). Maybe we don't have any actual users
> > that need it for now, but still..
> > 
> > Oh well.
> > 
> > I do wonder if we shouldn't just use something like
> > 
> >  "skip leading zeroes, copy to size-limited stack location instead"
> > 
> > because the input length really *is* limited once you skip leading
> > zeroes (and whatever base marker we have). We might have at most a
> > 64-bit value in octal, so 22 bytes max.
> > 
> > But I guess just changing the two GFP_KERNEL's to GFP_ATOMIC is much simpler.
> 
> 	There's match_strdup() as well...
> 
> 	FWIW, ext2 side also looks fishy; it might be cleaner if we
> collected new state into some object and applied it only after the last
> possible failure exit.  The entire "restore the original state" logics
> would go away...

Well, it's not like the restore logic would be that difficult for ext2. But
I agree that running the whole parsing logic under a spinlock is
unnecessary and accumulating all the changes in one structure and then
applying them looks like a cleaner way to go. I'll look into that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
