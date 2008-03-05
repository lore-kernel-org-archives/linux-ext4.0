From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH 1/1] add a jbd option to force an unclean journal
 state
Date: Tue, 04 Mar 2008 20:46:14 -0600
Message-ID: <47CE0976.70304@redhat.com>
References: <200803041339.42544.jbacik@redhat.com>	<20080304190109.GD24335@duck.suse.cz> <20080304155801.6f48bf08.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, jbacik@redhat.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYCECqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 21:46:21 -0500
In-Reply-To: <20080304155801.6f48bf08.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:

> So it's 100% scriptable and can be left running overnight, etc.  It found
> quite a few problems with ext3/jbd recovery which I doubt could be found by
> other means.  This was 6-7 years ago and I'd expect that new recovery bugs
> have crept in since then which it can expose.
> 
> I think we should implement this in a formal, mergeable fashion, as there
> are numerous filesystems which could and should use this sort of testing
> infrastructure.


FWIW, xfs has something vaguely similar, the XFS_IOC_GOINGDOWN ioctl,
which invokes xfs_fs_goingdown, which takes a few flags:

/*
 * Flags for going down operation
 */
#define XFS_FSOP_GOING_FLAGS_DEFAULT            0x0     /* going down */
#define XFS_FSOP_GOING_FLAGS_LOGFLUSH           0x1     /* flush log but
not data */
#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH         0x2     /* don't flush
log nor data */


but ultimately calls xfs_force_shutdown, which is sort of rougly similar
to ext3_abort....

The xfs qa tests make use of this ioctl.

-Eric

