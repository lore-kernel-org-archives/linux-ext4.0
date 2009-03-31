From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove /proc tuning knobs
Date: Tue, 31 Mar 2009 09:12:00 -0400
Message-ID: <20090331131200.GI13356@mit.edu>
References: <1235879288-26201-1-git-send-email-tytso@mit.edu> <1235879288-26201-2-git-send-email-tytso@mit.edu> <20090330101137.GC4796@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56921 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZCaNME (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 09:12:04 -0400
Content-Disposition: inline
In-Reply-To: <20090330101137.GC4796@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 03:41:37PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Feb 28, 2009 at 10:48:08PM -0500, Theodore Ts'o wrote:
> > Remove tuning knobs in /proc/fs/ext4/<dev/* since they have been
> > replaced by knobs in sysfs at /sys/fs/ext4/<dev>/*.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/ext4.h    |   16 -------
> >  fs/ext4/inode.c   |    7 +---
> >  fs/ext4/mballoc.c |  117 +++++++++++++----------------------------------------
> >  fs/ext4/super.c   |   46 ---------------------
> >  4 files changed, 30 insertions(+), 156 deletions(-)
> > 
> 
> This patch would need changes to Documentation/filesystems/proc.txt

Good point, added, thanks.

						- Ted
