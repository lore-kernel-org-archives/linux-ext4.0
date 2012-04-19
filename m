From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/6] ext4: status extents
Date: Wed, 18 Apr 2012 18:56:46 -0700
Message-ID: <20120419015646.GW15164@tux1.beaverton.ibm.com>
References: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35147 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2DSB5V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 21:57:21 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 18 Apr 2012 19:57:20 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B17543E40047
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 19:56:47 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3J1ulpH066984
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 19:56:47 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3J1ulus024951
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 19:56:47 -0600
Content-Disposition: inline
In-Reply-To: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 18, 2012 at 12:07:12AM -0700, Allison Henderson wrote:
> This set is based on the earlier delayed extent tree, but has
> been renamed to a "status extent" scheme.  The plan is that the
> tree will be expanded to track allocated extents and also
> support extent locks.  Thus status extents seemed like a
> more appropriate name.

How about "extent status tree" ?

> 
> Allison Henderson (6):
>   ext4: add two structures supporting status extent tree
>   ext4: add operations on status extent tree
>   ext4: initialize status extent tree
>   ext4: let ext4 maintian status extent trees

"maintain".

--D

>   ext4: reimplement fiemap on status extent tree
>   ext4: reimplement ext4_find_delay_alloc_range on status extent tree
> 
>  fs/ext4/Makefile         |    2 +-
>  fs/ext4/ext4.h           |    9 +-
>  fs/ext4/ext4_extents.h   |    3 +-
>  fs/ext4/extents.c        |  297 ++++-----------------------------
>  fs/ext4/indirect.c       |    3 +
>  fs/ext4/inode.c          |   83 ++++------
>  fs/ext4/status_extents.c |  417 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/status_extents.h |   40 +++++
>  fs/ext4/super.c          |   13 ++-
>  9 files changed, 545 insertions(+), 322 deletions(-)
>  create mode 100644 fs/ext4/status_extents.c
>  create mode 100644 fs/ext4/status_extents.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

