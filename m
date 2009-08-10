From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
Date: Mon, 10 Aug 2009 09:05:17 -0500
Message-ID: <4A80291D.6020200@sandeen.net>
References: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Lachlan McIlroy <lmcilroy@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:14480 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbZHJOFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2009 10:05:13 -0400
In-Reply-To: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lachlan McIlroy wrote:
> This looks good Eric.
> 
> Is this test just for quota accounting or should it be testing quota
> enforcement too?

I guess 108 just did accounting; I was going to keep it parallel, and do
a different one for accounting, but it could be added to this as well.

-Eric

> Lachlan
> 
> ----- "Eric Sandeen" <sandeen@redhat.com> wrote:
> 
>> Add some very basic quota sanity tests for generic filesystems.
>>
>> This is based on test 108, but uses the generic quota tools,
>> not xfs_quota, and therefore cannot test project quota.
>>
>> Also, the IOs are much smaller (48k) so that ext3 won't get into
>> indirect blocks and throw off the accounting.  This does
>> assume 4k blocks though.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---

...
