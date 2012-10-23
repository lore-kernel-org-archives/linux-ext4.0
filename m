From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Tue, 23 Oct 2012 23:47:27 +0100
Message-ID: <87k3ugn6v4.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix>
	<20121023221913.GC28626@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121023221913.GC28626@thunk.org> (Theodore Ts'o's message of
	"Tue, 23 Oct 2012 18:19:13 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 23 Oct 2012, Theodore Ts'o said:

> The reason why the problem happens rarely is that the effect of the
> buggy commit is that if the journal's starting block is zero, we fail
> to truncate the journal when we unmount the file system.

Oh dear oh dear.

>                                                           This can
> happen if we mount and then unmount the file system fairly quickly,
> before the log has a chance to wrap.

... which is quite likely if you're rebooting frequently to try to track
down some other kernel bug.

>                                       After the first time this has
> happened, it's not a disaster, since when we replay the journal, we'll
> just replay some extra transactions.  But if this happens twice, the
> oldest valid transaction will still not have gotten updated, but some
> of the newer transactions from the last mount session will have gotten
> written by the very latest transacitons, and when we then try to do
> the extra transaction replays, the metadata blocks can end up getting
> very scrambled indeed.

Ow. OK, it's a good thing I rebooted fast. :) and only fses that got
written to, but not too much, will see this. Hence my /usr/src stayed
intact because it had lots of updates of lots of tiny files, more than
enough to cause the journal to wrap over and over again, even
journalling only metadata. But /home doesn't see so many updates, and
neither does /var...

This seems to explain everything.

It looks like fscking everything will fix it (it'll replay the buggered
journal, mangling the metadata, but then fix up the scrambled metadata
and fix the journal's starting block). So I probably don't need to worry
about latent corruption hiding waiting to pounce. Phew.

> *Sigh*.  My apologies for not catching this when I reviewed this
> patch.  I believe the following patch should fix the bug; once it's
> reviewed by other ext4 developers, I'll push this to Linus ASAP.

No problem. This is my first data-corruption bug in more than seventeen
years of ext* use (it even survived horribly faulty RAM). I call that a
good record. And it happened one day after a full backup, and was
immediately highlighted by corruption of .bash_history and input/output
errors logging in -- and fsck pretty much fixed the problem, with only a
few missing files, one file full of garbage, and one high-ASCII filename
in a temporary directory to show for it. I call that luckier than I have
any right to be.

Plus, my faith in the amazingly fast bugfixing talents of ext4 devs is
undimmed! :)

> 						- Ted
>
> commit 26de1ba5acc39f0ab57ce1ed523cb128e4ad73a4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Oct 23 18:15:22 2012 -0400
>
>     jbd2: fix a potential fs corrupting bug in jbd2_mark_journal_empty

I'll apply this tomorrow (enough fun with filesystem restoration for
today) and see what happens. (What could *possibly* go wrong?)

But I might not upgrade to stable kernels quite so often in future :(
you know what they say: once burnt, twice not upgrading before doing a
full backup!

-- 
NULL && (void)
