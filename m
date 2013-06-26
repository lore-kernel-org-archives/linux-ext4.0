From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 14:03:45 -0400
Message-ID: <20130626180345.GA4128@thunk.org>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
 <20130626140205.GE3875@thunk.org>
 <20130626145417.GB32092@thunk.org>
 <CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
 <20130626163450.GA2487@thunk.org>
 <CAFy9=U5m5uew586C2eZJ7HjkRN5PvKr8+FoDdj8xtJoBeuP-_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: Nagachandra P <nagachandra@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33183 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3FZSDs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 14:03:48 -0400
Content-Disposition: inline
In-Reply-To: <CAFy9=U5m5uew586C2eZJ7HjkRN5PvKr8+FoDdj8xtJoBeuP-_A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 10:35:22PM +0530, Nagachandra P wrote:
> 
> These issue are not easy to reproduce!!! We are running multiple
> applications (of different memory size) over a period of a 24 hrs to
> 36 hrs and we hit this once. We have seen these issues easier to
> reproduce typically with around 512MB memory (may be in about 16 hrs -
> 20 hrs), and harder to reproduce with 1GB memory.
> 
> Most of the time we get into these situation are when an application
> (Typically AsyncTasks in Android) that is doing ext4 fs ops are of low
> adj values (> 9, typically 10 - 12) and hence would be fairly gullible
> to be killed (and there would be no way to distinguish this from
> application perspective), this is one of the challenges we are facing.
> Also, here we are don't have to completely be out of memory (but just
> withing the LMK band for the process adj value).

To be clear, if the application is killed by the low memory killer,
we're not going to trigger the ext4_std_err() codepath.  The
ext4_std_error() is getting called because free memory has fallen to
_zero_ and so kmem_cache_alloc() returns an error.  Should ext4 do a
better job with handling this?  Yes, absolutely.  I do consider this a
fs bug that we should try to fix.  The reality though is if that free
memory has gone to zero, it's going to put multiple kernel subsystems
under stress.

It is good to hear that this is only happening on highly memory
constrained devices --- speaking as a owner of a Nexus 4 with 2GB of
memory.  :-P

That's why the bigger issue is why did free memory go to zero in the
first place?  That means the LMK was probably not being aggressive
enough, or something started consuming a lot of memory too quickly,
before the page cleaner and write throttling algorithms could kick in
and try to deal with it.

> But, on rethinking your idea on retrying may work if we have some
> tweaks in LMK as well (like killing multiple tasks instead of just
> one).

You might also consider looking at tweaking the mm low watermark and
minimum watermark.  See the tunable /proc/sys/vm/min_free_kbytes.

You might want to just simply try monitorinig the free memory levels
on a continuous basis, and see how often it's dropping below some
minimum level.  This will allow you to give you a figure of merit by
which you can try tuning your system, without needing to wait for a
file system error.

Cheers,

					- Ted
