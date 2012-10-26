From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 16:56:18 -0400
Message-ID: <20121026205618.GC8614@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508AF3FA.4020506@redhat.com>
 <87wqydx957.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nix <nix-dKoSMcxRz+Te9xe1eoZjHA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87wqydx957.fsf-AdTWujXS48Mg67Zj9sPl2A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 26, 2012 at 09:37:08PM +0100, Nix wrote:
> 
> I can reproduce this on a small filesystem and stick the image somewhere
> if that would be of any use to anyone. (If I'm very lucky, merely making
> this offer will make the problem go away. :} )

I'm not sure the image is going to be that useful.  What we really
need to do is to get a reliable reproduction of what _you_ are seeing.

It's clear from Eric's experiments that journal_checksum is dangerous.
In fact, I will likely put it under an #ifdef EXT4_EXPERIMENTAL to try
to discourage people from using it in the future.  There are things
I've been planning on doing to make it be safer, but there's a very
good *reason* that both journal_checksum and journal_async_commit are
not on by default.

That's why one of the things I asked you to do when you had time was
to see if you could reproduce the problem you are seeing w/o
nobarrier,journal_checksum,journal_async_commit.

The other experiment that would be really useful if you could do is to
try to apply these two patches which I sent earlier this week:

[PATCH 1/2] ext4: revert "jbd2: don't write superblock when if its empty
[PATCH 2/2] ext4: fix I/O error when unmounting an ro file system

... and see if they make a difference.

If they don't make a difference, I don't want to apply patches just
for placebo/PR reasons.  And for Eric at least, he can reproduce the
journal checksum error followed by fairly significant corruption
reported by e2fsck with journal_checksum, and the presence or absense
of these patches make no difference for him.  So I really don't want
to push these patches to Linus until I get confirmation that they make
a difference to *somebody*.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
