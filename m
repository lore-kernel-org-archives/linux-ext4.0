From: Theodore Tso <tytso@mit.edu>
Subject: Re: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Fri, 27 Apr 2007 14:33:46 -0400
Message-ID: <20070427183345.GJ24852@thunk.org>
References: <4631FD7F.9030008@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42864 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbXD0Sdt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 14:33:49 -0400
Content-Disposition: inline
In-Reply-To: <4631FD7F.9030008@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 27, 2007 at 03:41:19PM +0200, Valerie Clement wrote:
> As asked by Alex, I included in the test results the file fragmentation 
> level and the number of I/Os done during the file deletion.
> 
> Here are the results obtained with a not very fragmented 100-GB file:
> 
>                  |     ext3       ext4 + extents      xfs
> ------------------------------------------------------------
>  nb of fragments |     796             798             15
>  elapsed time    |  2m0.306s        0m11.127s       0m0.553s
>                  |
>  blks read       |  206600            6416            352
>  blks written    |   13592           13064            104
> ------------------------------------------------------------

The metablockgroups feature should help the file fragmentation level
with extents.  It's easy enough to enable this for ext4 (we just need
to remove some checks in ext4_check_descriptors), so we should just do
it.

						- Ted
