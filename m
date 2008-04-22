From: Jan Kara <jack@suse.cz>
Subject: Re: ext3: Freeing blocks not in datazone
Date: Tue, 22 Apr 2008 11:31:46 +0200
Message-ID: <20080422093145.GB21922@atrey.karlin.mff.cuni.cz>
References: <4803A109.5080800@rtr.ca> <4803AF3B.2020702@redhat.com> <4803BF54.4040205@rtr.ca> <4803C5E4.3030804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Lord <lkml@rtr.ca>, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38846 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbYDVJbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 05:31:47 -0400
Content-Disposition: inline
In-Reply-To: <4803C5E4.3030804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Mark Lord wrote:
> > Eric Sandeen wrote:
> >> Mark Lord wrote:
> >>> One of my test systems here, running 2.6.25-rc8-git*,
> >>> just now crapped out with this in the tail end of dmesg:
> >>>
> >>> [   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
> >>> [   20.928756] Aborting journal on device sda1.
> >> I've got a similar report from the F9 installer, also on 2.6.25-rc8* ...
> >>  trying to reproduce locally.
> > ..
> > 
> > Well, if it's of any help, here it was on a 2.4GHz Intel QuadCore,
> > 32-bit kernel/userspace, 4GB RAM, PAE-enabled.
> 
> Any chance you had done a resize2fs, online or offline, before this?
> Just a guess based on the installer thing I'm looking at...
  Hmm, Eric, how exactly did the corruption looked like? Are you running
SLUB allocator? I'm just wondering whether it doesn't have something in
common with the memory corruption as discussed in the thread starting at
http://lkml.org/lkml/2008/4/19/85

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
