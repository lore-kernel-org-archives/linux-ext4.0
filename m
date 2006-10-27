From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 18:05:57 +0400
Message-ID: <m364e5svju.fsf@bzzz.home.net>
References: <20061027162326sho@rifu.tnes.nec.co.jp>
	<m3lkn2ryno.fsf@bzzz.home.net> <45420F76.90106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, sho@tnes.nec.co.jp, tytso@mit.edu,
	jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:35983 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1752200AbWJ0OEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 10:04:31 -0400
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <45420F76.90106@redhat.com> (Eric Sandeen's message of "Fri, 27 Oct 2006 08:53:58 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Eric Sandeen (ES) writes:

 ES> Alex Tomas wrote:
 >> 3) scalable reservation
 >> required for delayed allocation to avoid -ENOSPC at flush time.
 >> current version uses per-sb spinlock.

 ES> Can you elaborate on this issue?  Shouldn't delayed allocation
 ES> decrement free space immediately, and only the actual block location
 ES> choice is delayed?  Or is this due to potential extra metadata space
 ES> required as blocks are allocated?

exactly. in this case, reservation has nothing to do with allocation
or preallocation of real blocks. this is just a *per-sb counter* of
blocks reserved for allocation at flush time. it includes all
non-allocated-yet blocks and metadata needed to allocate them (bitmaps,
group descriptors, blocks extent tree, etc). the previous version
of mballoc has reservation, but it doesn't scale very well being
a single global counter protected by the spinlock. at least, in many
regular loads I observed the reservation function in top30 of oprofile.



thanks, Alex
