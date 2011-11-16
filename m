From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes (v2)
Date: Wed, 16 Nov 2011 22:50:41 +0100
Message-ID: <201111162250.42080.rjw@sisk.pl>
References: <4E1C70AD.1010101@u-club.de> <201110222335.29573.rjw@sisk.pl> <874ny4jhy4.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Christoph <cr2005@u-club.de>, "Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Linux PM list <linux-pm@vger.kernel.org>
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:42891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1KPVr7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 16:47:59 -0500
In-Reply-To: <874ny4jhy4.fsf@tac.ki.iif.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday, November 16, 2011, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Saturday, October 22, 2011, Christoph wrote:
> >
> >>> PM / Freezer: Freeze filesystems while freezing processes (v2)
> >>> 
> >>> On Sunday, August 07, 2011, Dave Chinner wrote:
> >>>
> >>>> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
> >>>>
> >>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>>> 
> >>>>> Freeze all filesystems during the freezing of tasks by calling 
> >>>>> freeze_bdev() for each of them and thaw them during the thawing of
> >>>>> tasks with the help of thaw_bdev().
> >>>>> 
> >>>>> This is needed by hibernation, because some filesystems (e.g. XFS) 
> >>>>> deadlock with the preallocation of memory used by it if the memory 
> >>>>> pressure caused by it is too heavy.
> >>>
> >>> Below is an alternative fix, the changelog pretty much explains the
> >>> idea.
> >>> 
> >>> I've tested it on Toshiba Portege R500, but I don't have an XFS
> >>> partition to verify that it really helps, so I'd appreciate it if
> >>> someone able to reproduce the original issue could test it and report
> >>> back.
> >> 
> >> Well, the kernel bugtracker is still down and I just like to post my
> >> experience with kernel (x64) v3.1-rc8/9 + patches. My machine is a
> >> MacBookPro, doomed with 4GB RAM running debian.
> >> 
> >> Bug #1
> >> 
> >> on the way to hibernate, machine hangs on
> >> 
> >> "PM: Preallocating image memory..."
> >> 
> >> this patch worked for me now for weeks:
> >> "[PATCH] PM / Freezer: Freeze filesystems while freezing processes (v2)"
> >> https://lkml.org/lkml/2011/9/24/77
> >
> > This patch is going to be merged into 3.2.
> 
> Hi,
> 
> I was the original reporter of the Bugzilla issue, just didn't know
> about this thread until recently.  Anyway, I'm running 3.2-rc1 now,
> which contains the alternative fix, and I can confirm that it indeed
> works: hibernation does not deadlock on my XFS rooted system anymore
> during memory preallocation.  Thanks everybody for his or her work on
> the issue!
> 
> To add something still, preallocation now ends with a couple of seconds
> of heavy disk activity, but with several seconds of total inactivity
> beforehand.  Is this warranted by some CPU intensive task at that stage?

Quilte frankly, I have no idea.

Thanks,
Rafael
