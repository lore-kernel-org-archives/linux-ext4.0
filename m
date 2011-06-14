From: Norbert Preining <preining@logic.at>
Subject: Re: another ext3 kernel BUG
Date: Tue, 14 Jun 2011 11:43:07 +0900
Message-ID: <20110614024307.GA3039@gamma.logic.tuwien.ac.at>
References: <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:35763 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1FNCnK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jun 2011 22:43:10 -0400
Content-Disposition: inline
In-Reply-To: <4DF6C541.5050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

thanks for the answer.

On Mo, 13 Jun 2011, Eric Sandeen wrote:
> Disassembly of your code might show which register has i_state ... I wonder if this could possibly be corruption of some sort?  It'd be nice to know what was found in i_state.   Modifying iput() to print it out prior to the bug_on might also help.  Just a thought.

Ok, I will try to patch something in and see what happens if I hit it
again.

> You seem uniquely able to hit it, and you do have a truckload of interesting modules loaded.  :)

Interesting modules?
alsa stuff, bluetooth, fuse/fat/vfat for ntfs/external drives, wlan
the only thing that stand out is the vbox* I guess, all the others are
pretty standard, aren't they?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CONDOVER (n.)
One who is employed to stand about all day browsing through the
magazine racks in the newsagent.
			--- Douglas Adams, The Meaning of Liff
