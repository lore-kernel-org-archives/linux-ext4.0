From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption with direct IO read in
 dioread_nolock mode
Date: Thu, 11 Apr 2013 23:18:37 -0400
Message-ID: <20130412031837.GA4865@thunk.org>
References: <1365438463-23025-1-git-send-email-jack@suse.cz>
 <20130411132036.GA3448@gmail.com>
 <20130411210756.GC9379@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33700 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3DLDSn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 23:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20130411210756.GC9379@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 11, 2013 at 11:07:56PM +0200, Jan Kara wrote:
>   Doh, you are right. I didn't notice that. Thanks for correcting me. I was
> seeing a failure in xfstest 091 (fsx using direct IO) with dioread_nolock
> and I thought the missing flush was the culprit (as fsx saw non-zeros in
> the tail of the page that was truncated). After adding the flush I didn't
> see it anymore. But now I'm not able to trigger the failure again
> regardless whether the patch is applied or not. So Ted, please drop the
> patch and I'll watch out if I ever see the failure again.

Dropped.

					- Ted
