From: Dave Jones <davej@redhat.com>
Subject: Re: ext4_da_release_space:1333: ext4_da_release_space: ino 12,
 to_free 1 with only 0 reserved data  blocks
Date: Wed, 31 Jul 2013 12:39:01 -0400
Message-ID: <20130731163901.GA10973@redhat.com>
References: <20130716202533.GA16061@redhat.com>
 <20130717125322.GA29294@quack.suse.cz>
 <20130717145218.GA27731@redhat.com>
 <20130717213850.GA5025@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3GaQjO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 12:39:14 -0400
Content-Disposition: inline
In-Reply-To: <20130717213850.GA5025@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 17, 2013 at 11:38:50PM +0200, Jan Kara wrote:
 > On Wed 17-07-13 10:52:18, Dave Jones wrote:
 > > On Wed, Jul 17, 2013 at 02:53:22PM +0200, Jan Kara wrote:
 > >  > On Tue 16-07-13 16:25:33, Dave Jones wrote:
 > >  > > I've seen this happen a few times this week..
 > >  >   Thanks for report! Was this when fuzzing or just normal desktop load?
 > >  > What is inode with inode number 12 on your filesystem sdb1? What IO happens
 > >  > to it? Apparently some delalloc accounting went wrong somewhere and it's
 > >  > searching for a needle in a haystack unless we have more details...
 > > 
 > > It was running this.. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
 > > in a loop. After about 6 hours, that fell out.  It made it all the way through
 > > every test a few times, which is odd, as the test should be fairly deterministic.
 > > Ah, I wasn't capturing the fsx seed. I'll do that on the next run.
 >   So inode 12 was likely the file used by fsx. OK. Looking at the script
 > link, fsx is run as:
 >   /usr/local/bin/fsx -N 250000 -S0 foo &
 > so the seed is always 0. So it is a deterministic test and there must be
 > some race with writeback or something that is rarely triggered. Drat.
 > 
 > Umm, looking at the filesystems this tests, ext4 with 1 KB blocksize is
 > likely the config which hits this (the accounting is more complex there) so
 > it might be interesting to concentrace on this one.

I just retried these tests, and hit this again.
I can confirm it happens on the 1k block filesystem.

	Dave


