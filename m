From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Sat, 11 May 2013 11:52:38 +0400
Message-ID: <871u9e6ji1.fsf@openvz.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <CA+8MBbKHJgnueAurRV1aeeV-NdzRTz_gVwYcJuyDrjJLErtcfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tony Luck <tony.luck@gmail.com>, eunb.song@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+8MBbKHJgnueAurRV1aeeV-NdzRTz_gVwYcJuyDrjJLErtcfg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 10 May 2013 10:27:58 -0700, Tony Luck <tony.luck@gmail.com> wrote:
Non-text part: multipart/mixed
> I think I have the same (or highly similar) thing happening on ia64.
What was page_size and fsblock size?
> 
> Similarities: seeing assertions fail for b_transaction
> Differences: I only have ext3 filesystems mounted, no ext4
> 
> See attached trace.  I'm pretty certain that the highly unhelpful
> 
>     bugcheck! 0 [1]
> 
> comes from the
> 
>         J_ASSERT_JH(jh, jh->b_transaction == NULL);
> 
> from disassembling __journal_remove_journal_head(). The instruction
> pointer <a0000001003d6690> points to the 2nd "break" instruction
> in the function.
> 
> The problem shows up after 30 minutes to a couple of hours of stress (kernel
> builds with "make -j32").
I cant reproduce this one yet.
But changes {ext3,jbd} are minimal
#git log --oneline v3.9.. fs/{ext3,jbd}
5af43c2 Merge branch 'akpm' (incoming from Andrew)
a27bb33 aio: don't include aio.h in sched.h
4385bab make blkdev_put() return void
14a9e5c Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
e760040 fs/buffer.c: remove unnecessary init operation after allocating buffer_head.
713685111 mm: make snapshotting pages for stable writes a per-bio
operation
8bb9da9 jbd: use kmem_cache_zalloc for allocating journal head
e162b2f jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
e678a4f jbd: don't wait (forever) for stale tid caused by wraparound
e643692 ext3: fix data=journal fast mount/umount hang

So looks very strange..
I have ia64 and now I work on reproduction.
> 
> I'm pretty sure this problem didn't occur in plain v3.9 (it can run for
> a full 24 hours).
> 
> Trying to bisect - but it takes a while to be convinced that a good kernel
> is actually good (since I don't have a clear picture of how long to run
> before deciding that the bug isn't going to show)
> 
> -Tony
Attachment: bug (application/octet-stream)
