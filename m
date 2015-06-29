From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Mon, 29 Jun 2015 16:49:00 -0400
Message-ID: <20150629204900.GA14839@thunk.org>
References: <20150625034626.GA21682@thunk.org>
 <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
 <20150627040237.GC474@thunk.org>
 <20150627140743.GF474@thunk.org>
 <20150629090437.GD11013@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150629090437.GD11013@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 29, 2015 at 11:04:37AM +0200, Jan Kara wrote:
> 
> BTW, what did you use to trigger the error for you? The ext4 path where the
> assertion triggered for Linus is definitely correct so the assertion
> failure was a false positive.

I've managed to trigger it twice in about 5 or 6 full runs of
"./kvm-xfstests -g auto".  Once it was with generic/233 in 1k block
file system mode, the second time it was generic/233 in ext3 compat
mode.  i've tried running just generic/233, and it doesn't trigger.
"i.e., "./kvm-xfstests -C 10 generic/233" didn't trigger the bug.

(I'm currently on vacation, so I've been kicking off the run each
morning or evening and then checking to see if it blew up or not.)

Cheers,

						- Ted
