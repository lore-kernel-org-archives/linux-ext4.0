From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/4] ext4: fix reserved space transferring on chown() [V2]
Date: Wed, 09 Dec 2009 05:03:54 +0300
Message-ID: <87ein4sy2d.fsf@openvz.org>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
 <20091207171835.GB16078@skywalker.linux.vnet.ibm.com>
 <87ocmalgh0.fsf@openvz.org> <20091209014259.GV27692@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:36740 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZLICDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 21:03:43 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUD007UN4M6Z460@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 09 Dec 2009 05:08:35 +0300 (MSK)
In-reply-to: <20091209014259.GV27692@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Mon, Dec 07, 2009 at 10:41:15PM +0300, Dmitry Monakhov wrote:
>> Absolutely right. I've fixed an issue, but overlooked the BIGGEST one.
>> So off course my patch is wrong, even if we will acquire lock in
>> different order " dqptr_sem > i_block_reservation_lock"
>> we sill getting in to sleeping  spin lock problems by following scenario:
>> ext4_da_update_reserve_space()
>> ->dquot_claim_space()
>> ASSUMES that we hold i_block_reservation_lock here.
>> -->mark_dquot_dirty()
>> --->ext4_write_dquot()
>>     if (journalled quota) ext4_write_dquot();
>> ---->dquot_commit()
>> ----->mutex_lock(&dqopt->dqio_mutt's); <<< sleep here.
>> 
>> This means that we have fully redesign quota reservation locking. 
>> As i already suggested previously here:
>> http://thread.gmane.org/gmane.comp.file-systems.ext4/16576/focus=16587 
>
> Given this, should I include this patch for now, given that it does
> fix _one_ race, or should I hold off until you redo the locking?  How
> long do you think to send a revised/new patch?
Please wait until good version will be approved all involved people.
I've already prepared and tested RFC version which solves all known
issues. I'll send patch set in a minute.
