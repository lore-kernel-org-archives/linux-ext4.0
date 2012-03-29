From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: GIT PULL] ext4 updates for 3.4
Date: Thu, 29 Mar 2012 08:41:07 +0800
Message-ID: <20120329004107.GA25447@localhost>
References: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
 <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
 <CA+55aFy+go3EwPeQcdv+kvy3vQ2Qxcoizoap8MFGKqSC42ajFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2C2AqW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 20:46:22 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFy+go3EwPeQcdv+kvy3vQ2Qxcoizoap8MFGKqSC42ajFg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 28, 2012 at 04:45:55PM -0700, Linus Torvalds wrote:
> On Wed, Mar 28, 2012 at 4:36 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I have no real data for this, though - just a "mouse pointer
> > occasionally freezing up". So I'm looking for a potential "hmm, that
> > makes me wonder if..." kind of reaction.
> 
> Heh. It may have been that my wireless mouse was having some issue
> syncing properly with the receiver. I unplugged and replugged the
> receiver, and I seem unable to reproduce the problem. So this may have
> been just an actual hardware latency issue, rather than the kernel
> having bad latency.

Yeah my wireless mouse also becomes insensitive nowadays (perhaps
running low on battery power?)

> But if it made you go "hmm, I should check xyz", please do go ahead
> and check it anyway, just in case ;)

I just booted into the new kernel, did some compile testing and it looks good.

Anyway the classical "mouse pointer freezing up" problems are often
caused by waits in direct page reclaim and can be confirmed with large

allocstall      # the number of direct reclaims
nr_vmscan_write # the number of pageout()s

numbers in /proc/vmstat


FYI I'm testing desktop responsiveness remotely (as you know it could
be a painful test). The test scheme is to run

        make -j16  (or any other workloads)

as well as a small script to start some X apps and cycle through the
windows. By checking if there are second(s) long gaps in the below
progress messages, I confirm that the desktop is running smoothly.

 time         window title
  157.68    A swapping-desktop-test
  157.73    A *Unsaved Document 1 - gedit
  157.76    A Restore Session - Iceweasel
  157.80    A Sudoku
  157.83    A LibreOffice 3.4
  157.91    A System Settings
  158.01    A urxvt
  158.01    A xeyes
  158.06    A bay:/home/wfg/swapping-desktop-test - ZSH
  158.08    A Xpdf: /usr/share/doc/shared-mime-info/shared-mime-info-spec.pdf
  158.10    A bay:/home/wfg/swapping-desktop-test - ZSH
  158.17    A OpenOffice.org
  158.20    A OpenOffice.org
  158.21    A OpenOffice.org
  158.22    A OpenOffice.org
  158.24    A OpenOffice.org
  158.25    A Dictionary
  158.27    A bay:/home/wfg/swapping-desktop-test - ZSH
  158.30    A Tetravex
  158.34    A Chess
  158.37    A System Monitor
  158.41    A Mines
  158.50    A Robots
  158.62    A Iagno
  158.68    A Four-in-a-row
  158.75    A Five or More
  158.79    A Klondike
  158.82    A Klotski
  158.90    A Mahjongg - Easy
  158.93    A Tali
  159.00    A Desktop Help
  159.08    A Home

Thanks,
Fengguang
