From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - jbd-strictly-check-for-write-errors-on-data-buffers.patch
 removed from -mm tree
Date: Tue, 10 Jun 2008 02:17:46 -0700
Message-ID: <20080610021746.51e5cfa8.akpm@linux-foundation.org>
References: <200806092212.m59MC553010889@imap1.linux-foundation.org>
	<484E4097.2010204@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYFJJRx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 05:17:53 -0400
In-Reply-To: <484E4097.2010204@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 10 Jun 2008 17:51:35 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Hello Andrew,
> 
> akpm@linux-foundation.org wrote:
> 
> > The patch titled
> >      jbd: strictly check for write errors on data buffers
> > has been removed from the -mm tree.  Its filename was
> >      jbd-strictly-check-for-write-errors-on-data-buffers.patch
> > 
> > This patch was dropped because I don't think we want to go read-only on file data write errors
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject: jbd: strictly check for write errors on data buffers
> > From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> 
> This patch series doesn't change the behavior on file data write
> errors as I stated before, but we found that the current behavior has
> been made accidentally.  So yesterday I sent an additional patch(*)
> which removes the invocation of journal_abort() and thus stop making
> the fs read-only on file data write errors, but it seems to be late
> for the -mm release preparation.
> 
>   Patch(*) can be found at:
>   http://marc.info/?l=linux-kernel&m=121300618614453&w=2
> 
> Anyway, as this patch series was dropped from -mm, I'm going to
> send a revised version.
> 
> I plan to separate these pathces into three patche set. 
> The first patch (set) corrects the current behavior in ordered
> writes, it means it removes the invocation of journal_abort() on file
> data write errors.  It is the almost same as the patch(*).
> The second patch set fixes error handlings for metadata writes and
> checkpointing.  It should be applied independently of the first
> patch set, and it is the same as PATCH 3/5 to 5/5.
> The third patch set makes "abort the journal on file data write errors"
> tunable for mission critical users.  Of course, this feature depends
> on the first patch set.
> 

That sounds like a good plan, thanks.
