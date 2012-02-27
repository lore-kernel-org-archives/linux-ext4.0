From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] e2fsck: Discard only unused parts of inode table
Date: Mon, 27 Feb 2012 00:42:27 -0500
Message-ID: <20120227054227.GB9881@thunk.org>
References: <1330014566-2020-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, psusi@ubuntu.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39742 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2B0Fmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 00:42:44 -0500
Content-Disposition: inline
In-Reply-To: <1330014566-2020-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 23, 2012 at 05:29:25PM +0100, Lukas Czerner wrote:
> When calling e2fsck with '-E discard' option it might happen that
> valid inodes are discarded accidentally. This is because we just
> discard the part of inode table which lies past the highest used
> inode. This is terribly wrong (sorry!).

Is this description accurate?  We *do* want to discard the part of the
inode table past the highest used inode number.  By definition
everything past that to the end of the bg's inode table is unsued,
right?  The problem was before we were using the free inode count as I
understand things.

						- Ted
