From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 17 Aug 2007 02:02:53 -0700
Message-ID: <20070817020253.ed331f36.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<20070427013350.d0d7ac38.akpm@linux-foundation.org>
	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	<20070427193130.GD5967@schatzie.adilger.int>
	<20070427151837.f1439639.akpm@linux-foundation.org>
	<463A1E02.8020506@clusterfs.com>
	<20070503165428.855eb7d7.akpm@linux-foundation.org>
	<463AD024.6060208@clusterfs.com>
	<20070503233804.9dace4a7.akpm@linux-foundation.org>
	<463AD948.9090103@clusterfs.com>
	<20070504001802.0e86e9dd.akpm@linux-foundation.org>
	<463AE32A.5000902@clusterfs.com>
	<20070504010212.ce6eca53.akpm@linux-foundation.org>
	<46C49556.4000409@clusterfs.com>
	<20070816114605.5a233c7e.akpm@linux-foundation.org>
	<46C506EF.5010408@clusterfs.com>
	<20070816235250.d1e39b79.akpm@linux-foundation.org>
	<46C55E10.900@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757608AbXHQJDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2007 05:03:40 -0400
In-Reply-To: <46C55E10.900@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 17 Aug 2007 12:36:32 +0400 Alex Tomas <alex@clusterfs.com> wrote:

> Andrew Morton wrote:
> > Sort-of.  But the per-superpblock, per-inode writeback code is pretty
> > careful to avoid livelocks.  The per-inode writeback is a strict single
> > linear sweep across the file.  It'll basically write out anything which was
> > dirty when it was called.  The per-superblock inode walk isn't as accurate
> > as that, becuase of the difficulties of juggling list_heads.  But we're
> > slowly working on that, and I suspect it'll be ggod enough for ext3
> > purposes already.
> 
> I'd say that these are two different mechanism solving different problems:
> 1) VFS/MM does periodic updates and uses regular writeback
> 2) data=ordered is to avoid metadata pointing to not-written-yet data

VFS/MM can do _much_ more than that!  Look at struct writeback_control.

That code path has many different modes of operation: it is used for
regular pdflush writeback, sync, fsync, throttling, etc.  Probably one of
its modes will be sufficient.  If we want to change ext3's existing
semantics and add an "only writeback uninitialised blocks" mode then
that'll be pretty straightforward: add more control information to
writeback_control and go for it.

> we can't use regular writeback in commit thread as long as it can fall into
> allocation. so, we'd have to add one more WB mode (btw, i have a patch which
> skips non-allocated blocks in writeback if special WB mode is requested).

yup

> OTOH, the faster we go through data sync part of commit, the better. given
> that lots of inodes can be dirty with no data to sync, it's going to take
> long in some cases. it's especially bad because commit doesn't scale to many
> CPUs.

eh?

> also, why would we need to flush *everything* every 5s? just because ext3 does
> this? sounds strange. if somebody really need this we could add this possibility
> to regular writeback path (making it tunable). but I'd rather prefer to have
> a separate (fast, lightweight, scalable) mechanism to support data=ordered.
> 

Yeah, that would make sense, perhaps.

Or just speed the existing stuff up.  iirc the main problem in there is unrelated
to data writeback.  There are situations where the running transaction has to block
behind metadata writeout which the committing transaction is performing.  I
reluctantly put that in years ago to get us out of a tight spot and it
never got optimised.
