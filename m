From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Mon, 20 Oct 2008 23:37:26 -0700
Message-ID: <20081020233726.5682a278.akpm@linux-foundation.org>
References: <48FC081D.60306@hitachi.com>
	<20081019221331.ddf6b8c2.akpm@linux-foundation.org>
	<20081020124145.GB10698@mit.edu>
	<48FD75AF.6080507@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, adilger@sun.com, jack@suse.cz,
	sandeen@redhat.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJUGhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2008 02:37:51 -0400
In-Reply-To: <48FD75AF.6080507@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 21 Oct 2008 15:24:47 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> >>One of the above patches (I forget which) breaks the build because it
> >>expects the presence of Al Viro's VFS tree, and that hasn't been merged
> >>yet.  I need to wait and see if that merge will be happening (seems
> >>unlikely) and if not, rework the patch against mainline.
> 
> I see.  Thank you for your work.
> 
> > Strange; I don't recall any of the ext4 variants of the error handling
> > patches requiring Al's VFS tree.  And I thought all of them have been
> > merged into Linus's tree at this point.
> 
> I checked Al's VFS tree and I found commit
> 6ac465f99b29f74ca5a62bc32a8772985d9a071b changes codes near where
> one of my patch changes (in ext3/ext4_quota_on()), but not the same code.

OK.

Don't worry about it - I'll fix things up some time this week.
