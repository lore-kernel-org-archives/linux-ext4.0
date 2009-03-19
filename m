From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Thu, 19 Mar 2009 11:42:03 -0500
Message-ID: <49C275DB.2060906@redhat.com>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu> <49C075FC.6070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZCSQmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2009 12:42:18 -0400
In-Reply-To: <49C075FC.6070404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Ts'o wrote:
>> Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
>> this mode, we force all delayed allocation blocks involved with the
>> to-be-commited transaction to be allocated, and then flushed out to
>> disk before the transaction is commited.
>>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Haven't really looked into the cause yet but I was playing with this,
> and ran:
> 
> # rm -f bigfile smallfile; dd if=/dev/zero of=bigfile bs=1M count=8192;
> echo boo > smallfile; time /root/fsync smallfile; time /root/fsync bigfile
> 
> which resulted in:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffffa02a6de1>] alloc_on_commit_callback+0x27/0x7f [ext4]

This may have been user error ... ignore for now, I'll follow up if I
decide it's real.  :)

-Eric
