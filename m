From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Sat, 20 Jul 2013 20:56:36 -0400
Message-ID: <20130721005636.GA21484@thunk.org>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
 <20130720163737.GA8870@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130720163737.GA8870@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 21, 2013 at 12:37:37AM +0800, Zheng Liu wrote:
> 
> Now ext4 tree has not yet rebased against 3.11-rcX.  So it seems that
> vfs tree is better if we want to fix this bug in mainline kernel as soon
> as possible.

I was going to rebase the ext4 tree to Linus's current tree just to
get this patch in.  I think it would be good to get this fix before
-rc2, so either you or I should get this to Linus ASAP.

So Al, if you're going to send vfs patches to Linus this weekend (say,
to fix the equivalent bug for ext3), go for it.  Otherwise, let me
know and I'll send Linus a one-commit pull request just to get this
fix in.

Cheers,

						- Ted
