From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 4 Jan 2008 21:12:28 -0700
Message-ID: <20080105041228.GP3351@webber.adilger.int>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:46104 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYAEEMc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 23:12:32 -0500
Content-Disposition: inline
In-Reply-To: <477E379F.4000103@student.ltu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 04, 2008  14:41 +0100, Richard Knutsson wrote:
>>  @@ -54,6 +54,6 @@ int __ext4_journal_dirty_metadata(const char *where,
>>  {
>>  	int err = jbd2_journal_dirty_metadata(handle, bh);
>>  	if (err)
>> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
>> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>>  	return err;
>>  }
>
> What about changing the __FUNCTION__ to __func__, while you are at it?

What's wrong with __FUNCTION__?  I thought that was ANSI C?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
