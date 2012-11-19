From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/8 v3] ext4: extent status tree (step 1)
Date: Sun, 18 Nov 2012 22:17:25 -0500
Message-ID: <20121119031725.GA24414@thunk.org>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeff.liu@oracle.com, hughd@google.com,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	lczerner@redhat.com, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33476 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab2KSDRg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Nov 2012 22:17:36 -0500
Content-Disposition: inline
In-Reply-To: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 26, 2012 at 09:23:37PM +0800, Zheng Liu wrote:
> Hi all,
> 
> Here is the v3 of extent status tree.  In this version, the biggest change is
> the i_es_lock (a rwlock_t) instead of i_data_sem, which is introduced to protect
> extent status tree.  Moreover I improve the SEEK_DATA/SEEK_HOLE.  In previous
> version, the unwritten extent is as a data, and now it will lookup page cache to
> determine it as a data or a hole.  When it has some data at the given range, the
> unwritten extent will be as a data.  Otherwise, it will be as a hole.  Other
> changes contain some bug fixes.

I don't think I ack'ed this patch series earlier; my apologies.  In
any case (with the comment fixup we discussed earlier), It's currently
queued for the next merge window.

Regards,

						- Ted
