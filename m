From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Mon, 5 Dec 2011 15:38:36 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1LEXjD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 18:39:03 -0500
Received: by iakc1 with SMTP id c1so2753990iak.19
        for <linux-ext4@vger.kernel.org>; Mon, 05 Dec 2011 15:39:02 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.1111211331120.1879@sister.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 21 Nov 2011, Hugh Dickins wrote:
> On Mon, 21 Nov 2011, Ted Ts'o wrote:
> > On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
> > > On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
> > > It appears that there's a bug with this patch:

This has been outstanding for a month now, and we've heard no progress:
please revert commit 02fac1297eb3 "ext4: fix partial page writes" for rc5.

The problems appear on a 1k-blocksize filesystem under memory pressure:
the hunk in ext4_da_write_end() causes oops, because it's playing with
a page after generic_write_end() dropped our last reference to it; and
backing out the hunk in ext4_da_write_begin() is then found to stop
rare data corruption seen when kbuilding.

Although I earlier reported that backing out the patch caused an fsx
test to fail earlier, I've since found great variation in how soon it
fails, and seen it fail just as quickly with 02fac1297eb3 still in.
I also reported that I had to go back to 2.6.38 for fsx not to fail
under memory pressure: you won't be surprised that that turned out to
be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_submit.

Thanks,
Hugh
