From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH, RFC] Ext3: Mount partition as read only if during orphan
 cleanup truncate fails to obtain journal handle.
Date: Mon, 29 Oct 2012 16:37:17 +0530
Message-ID: <CAOiN93=p-EOiRWOs=mw52zkQtFy=6Tg7PgJ7HT=drcgFKWCNdw@mail.gmail.com>
References: <1351075364-2886-1-git-send-email-ashish.sangwan2@gmail.com>
	<20121029104939.GB18767@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35457 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2J2LHS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 07:07:18 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so5071186vcb.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2012 04:07:17 -0700 (PDT)
In-Reply-To: <20121029104939.GB18767@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 4:19 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 24-10-12 16:12:44, Ashish Sangwan wrote:
>> During orphan cleanup while doing truncate, if we fail to obtain journal
>> handle, the inode for which truncate was called would not be removed from
>> both the on-disk and in-memory orphan lists as the call to ext3_orphan_del
>> would not be executed.
>>
>> This would have following consequences:
>> a) As the inode is not removed from the on-disk list, truncate would be
>> called again for the same inode. Each call would add the inode to the
>> in-memory list. This operation would continue endlessly or until truncate
>> is succeed.
>>
>> b) If somehow, after some iterations, truncate is succeed, ext3_orphan_del
>> will only remove the inode from in-memory list just 1 time. This will trigger
>> j_assert during put super.
>>
>> This patch handles both the problems. If truncate fails, first in-memory
>> list is cleared and than the partition is mounted as read only.
>> Failure to obtain journal handle during mount may suggest that journal
>> device is corrupted.
>   Could you really trigger any of the described bugs? Because
> ext3_truncate() does take care to remove inode from orphan list even if
> starting of a transaction fails (see out_notrans label in ext3_truncate()).
Sorry, my bad. Did'nt notice out_notrans tag.
Actually, its just ext4 which does not clear orphan list.
Please ignore this patch.

Thanks,
Ashish
> Also spitting additional messages should be unnecessary - the error which
> caused truncate to fail should have logged the error message and also taken
> appropriate action depending on filesystem configuration (i.e., remount fs
> read-only, panic the system, or do nothing).
>
