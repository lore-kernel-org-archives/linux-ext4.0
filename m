From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: Handle nested ext4_journal_start/stop calls
	without a journal
Date: Thu, 17 Sep 2009 23:50:10 -0600
Message-ID: <20090918055010.GN2537@webber.adilger.int>
References: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62018 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZIRFuH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 01:50:07 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8I5oAIQ020900
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 22:50:11 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ500300K4DU600@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 17 Sep 2009 22:50:10 -0700 (PDT)
In-reply-to: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2009  14:55 -0700, Curt Wohlgemuth wrote:
> This patch fixes a problem with handling nested calls to
> ext4_journal_start/ext4_journal_stop, when there is no journal present.
> 
> 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> 
> Instead of using the special value of
> 
>         (handle_t *)0x1
> 
> to represent a handle when there is no journal present, we now use a real
> handle_t, so we can use its ref counting.  The h_transaction field now
> determines if there is a journal present or not.

You _could_ just use the "handle" value as a refcount, and anything less
than, say, 4096 is considered a "special" handle.  I can't imagine the
refcount being more than 3 or 4 even in extreme cases.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

