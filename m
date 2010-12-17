From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: handle exactly-16T filesystems in resize2fs
Date: Thu, 16 Dec 2010 19:15:57 -0500
Message-ID: <20101217001557.GE4455@thunk.org>
References: <4D09978E.5050302@redhat.com>
 <alpine.LFD.2.00.1012160957320.2781@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53412 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0LQAP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 19:15:59 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012160957320.2781@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 16, 2010 at 10:00:26AM +0100, Lukas Czerner wrote:
> 
> which version of e2fsprogs are you referring to ? When I look at master
> branch I can see than those changes are already in there. Except the check
> if the new size is too large. Am I missing something ?

The 1.41.x series is on the "maint" branch.

The 1.42 version is on the main "master" and "next" branch, where
"next" is where I'll check in things initially, and then "master"
catches up with "next".  I took this from git, with the basic idea
being that if there are people who are testing next, and people who
are using the "master", hopefully problems get noticed and fixed
before people are using "master" grab a commit.  To be honest there
probably aren't enough people tracking next and master for this to
make a huge amount of difference, but I'm following this scheme
anyway.

					- Ted
