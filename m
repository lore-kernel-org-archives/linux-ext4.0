From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 2/3 v2] 285: Fix indentation of do_pwrite
Date: Fri, 31 May 2013 07:30:20 -0500
Message-ID: <51A897DC.1030801@sgi.com>
References: <1369948905-6693-1-git-send-email-jack@suse.cz> <1369948905-6693-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:35099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754596Ab3EaM30 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 08:29:26 -0400
In-Reply-To: <1369948905-6693-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/30/2013 04:21 PM, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   src/seek_sanity_test.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
Thanks for the patch, it has been committed:

commit 1515c26fd44ee2f84ce43ebcd9168130801dd9a0
Author: Jan Kara <jack@suse.cz>
Date:   Fri May 31 07:19:47 2013 -0500

     xfstests 285: Fix indentation of do_pwrite

--Rich
