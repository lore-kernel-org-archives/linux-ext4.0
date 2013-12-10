From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Filesystem writes on RAID5 too slow
Date: Tue, 10 Dec 2013 11:18:03 -0800
Message-ID: <20131210191803.GA31162@infradead.org>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
 <528A5C45.4080906@redhat.com>
 <20131119005740.GY6188@dastard>
 <CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
 <20131121092606.GU11434@dastard>
 <CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
 <CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
 <20131121234116.GD6502@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Boutin <martboutin@gmail.com>,
	"Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LJTSH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 14:18:07 -0500
Content-Disposition: inline
In-Reply-To: <20131121234116.GD6502@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> xfs: align initial file allocations correctly.
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> The function xfs_bmap_isaeof() is used to indicate that an
> allocation is occurring at or past the end of file, and as such
> should be aligned to the underlying storage geometry if possible.
> 
> Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
> behaviour of this function for empty files - it turned off
> allocation alignment for this case accidentally. Hence large initial
> allocations from direct IO are not getting correctly aligned to the
> underlying geometry, and that is cause write performance to drop in
> alignment sensitive configurations.
> 
> Fix it by considering allocation into empty files as requiring
> aligned allocation again.

Seems like this one didn't get picked up yet?

