From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][e2fsprogs] New bitmap and inode table allocation for
 FLEX_BG
Date: Thu, 3 Apr 2008 09:28:58 -0500
Message-ID: <20080403092858.5e3a7bb2@gara.konoha.net>
References: <20080401031311.10442.12267.stgit@gara.konoha.net>
	<20080403131240.GA13486@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41638 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243AbYDCO3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 10:29:07 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m33ET6Lx024886
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 10:29:06 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m33ET6qE239092
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 10:29:06 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m33ET6b5015772
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 10:29:06 -0400
In-Reply-To: <20080403131240.GA13486@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Apr 2008 09:12:40 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Mar 31, 2008 at 10:13:11PM -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > New bitmap and inode table allocation for FLEX_BG
> > 
> > Change the way we allocate bitmaps and inode tables if the FLEX_BG
> > feature is used at mke2fs time.  It places calculates a new offset for
> > bitmaps and inode table base on the number of groups that the user
> > wishes to pack together using the new "-G" option.  Creating a
> > filesystem with 64 block groups in a flex group can be done by:
> 
> I was just testing out this patch, and it looks like it creates a
> filesystem with an incorrect free blocks count when creating a
> filesystem with both uninit_groups and flex_bg.  Can you look at this,
> please?
> 
> 						- Ted

I blame Undo Manager for being so slow that cause me to skip some of
the testing needed to be done.  I was incorrectly checking the feature
flag instead of checking the value of fs->super->s_log_groups_per_flex.

Fixed patch is on its way.

 -JRS
