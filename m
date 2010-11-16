From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH resend]  jbd2_stats_proc_init wrong place.
Date: Tue, 16 Nov 2010 16:01:07 -0500
Message-ID: <20101116210107.GB1568@thunk.org>
References: <1289892704-27147-1-git-send-email-sheng.yang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, andreas.dilger@oracle.com,
	linux-fsdevel@vger.kernel.org
To: yangsheng <sheng.yang@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39184 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab0KPVBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 16:01:11 -0500
Content-Disposition: inline
In-Reply-To: <1289892704-27147-1-git-send-email-sheng.yang@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 03:31:44PM +0800, yangsheng wrote:
>  The jbd2_stats_proc_init() was placed on wrong location in
>  jbd2_journal_init_dev().  This may cause /proc/fs/jdb2/<dev>/*
>  cannot be created when using external journal device.
> 
>  Reviewed-by: Andreas Dilger <andreas.dilger@oracle.com>

Hi Yang Sheng --- you didn't add a Signed-off-by line.  Can you
confirm that it was your intention to add a:

Signed-off-by: yangsheng <sheng.yang@oracle.com>

... per the "Developer's Certificate of Origin 1.1" as found in
/usr/src/linux/Documentation/SubmittingPatches?

Many thanks,

					- Ted
