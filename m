From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext2/super: Fix a possible sleep-in-atomic bug in
 parse_options
Date: Sat, 7 Oct 2017 03:28:39 +0100
Message-ID: <20171007022839.GP21978@ZenIV.linux.org.uk>
References: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
 <CA+55aFw9UB1ZKMk-JgLm=xBRST-9JaWv4unFtE3fsygjeVxEjg@mail.gmail.com>
 <20171007020217.GN21978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jia-Ju Bai <baijiaju1990@163.com>, Jan Kara <jack@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, james.smart@broadcom.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171007020217.GN21978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 07, 2017 at 03:02:17AM +0100, Al Viro wrote:
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

	I'm not saying that the bug had been introduced by conversion to
spinlock, BTW - it was racy back when ext2_remount() relied upon BKL.
I hadn't considered the atomicity issues back then - mea culpa...
