From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Ext4: wait for log to commit when putting super
Date: Mon, 07 Dec 2009 14:39:44 -0600
Message-ID: <4B1D6810.40204@redhat.com>
References: <20091207200924.GB8558@localhost.localdomain> <4B1D64ED.5060403@redhat.com> <20091207203156.GC8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934836AbZLGUjj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 15:39:39 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB7Kdkks026684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 15:39:46 -0500
In-Reply-To: <20091207203156.GC8558@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:
> On Mon, Dec 07, 2009 at 02:26:21PM -0600, Eric Sandeen wrote:
>> Josef Bacik wrote:
>>> There is a problem where a transaction will be committing while we're unmounting
>>> the filesystem and you will get a panic because EXT4_SB(sb)->s_group_info has
>>> been kfree'ed in ext4_put_super.  The commit code does the callback for the
>>> mballoc stuff to release free'ed blocks in the transaction and panic's trying to
>>> access s_group_info.  The fix is to wait for the transaction to finish
>>> committing before we start cleaning up the mballoc stuff.  This patch hasn't
>>> been tested yet, but its an obvious fix.
>> Hm, doesn't jbd2_journal_destroy already do that, but we just
>> call it -after- we've done ext4_mb_release which leads to freeing
>> EXT4_SB(sb)->s_group_info ?
>>
>> Can we just do jbd2_journal_destroy() earlier before we tear
>> down things it may depend on?
>>
> 
> That seems reasonable.  We do
> 
>         ext4_release_system_zone(sb);
>         ext4_mb_release(sb);
>         ext4_ext_release(sb);
>         ext4_xattr_put_super(sb);
> 
> before the journal_destroy, and all thats doing is cleaning up our internal
> stuff.  If we want to keep it close to what ext3 does we can just move
> 
>         ext4_release_system_zone(sb);
>         ext4_mb_release(sb);
>         ext4_ext_release(sb);
> 
> under the journal_destroy or just move the journal destroy above all of that
> stuff.  Whichever you prefer.  Thanks,

I guess it doesn't matter much to me, I just preferred rearranging
teardown order to adding more logic that I think is already taken care
of in the jbd2_journal_destroy call ..

Thanks for finding this! :)

-Eric

> Josef

