From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Mon, 19 May 2008 22:34:55 -0400
Message-ID: <20080520023454.GM15035@mit.edu>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62243 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756582AbYETChS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 22:37:18 -0400
Content-Disposition: inline
In-Reply-To: <482DDC04.7020706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
> To ensure that bits are truly on-disk after an fsync,
> we should call blkdev_issue_flush if barriers are supported.

This patch isn't necessary, and in fact will cause a double flush.
When you call fsync(), it calls ext4_force_commit(), and we do a the
equivalent of a blkdev_issue_flush() today (which is what happenes
when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
set_ordered_mode(bh) ends up causing.

						- Ted
