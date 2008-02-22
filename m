From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 08:16:22 -0500
Message-ID: <20080222131622.GK20118@mit.edu>
References: <47BDF6C9.8090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	pspencer@fields.utoronto.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33092 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758891AbYBVNR1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 08:17:27 -0500
Content-Disposition: inline
In-Reply-To: <47BDF6C9.8090009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2008 at 04:10:17PM -0600, Eric Sandeen wrote:
> This is for RH Bugzilla #433857: 
> rpc.mountd segfaults due to uninitialized value in e2fsprogs devname.c
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=433857
> 
> which did some very helpful analysis & provided a patch.
> 
> This patch is based on that, but checks all the devicemapper calls,
> and does some goto error handling / unwrapping, in the same style as
> the device-mapper lib code itself.

This looks good, but I assume that the bug was caused by some race
condition where if you try to call dm_task_get_info() while some other
process is creating or removing a snapshot, dm_task_get_info() is
returning some kind of EAGAIN, or some other "Try again; we're busy"
error, right?

If that is the case, can you try to find out what error is being
returned?  It may be the right thing to do is to check to see if we
are getting a "resource is locked; try again in a sec" error message,
and retry the dm_task_get_info(), instead of just returning a failure.

Thanks!!

						- Ted
