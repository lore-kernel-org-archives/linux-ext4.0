From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v2 5/5] ext4: remove alloc_semp
Date: Tue, 10 May 2011 21:20:58 +0300
Message-ID: <BANLkTimQbrOVDpgZGmhT9-rzMWEjVgkf4A@mail.gmail.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
	<1300985893-4371-6-git-send-email-amir73il@users.sourceforge.net>
	<20110510132910.GA6933@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42286 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1EJSU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 14:20:59 -0400
Received: by vxi39 with SMTP id 39so6899746vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 11:20:58 -0700 (PDT)
In-Reply-To: <20110510132910.GA6933@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 4:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 24, 2011 at 06:58:13PM +0200, amir73il@users.sourceforge.=
net wrote:
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> After taking care of all group init races, all that remains is to
>> remove alloc_semp from ext4_allocation_context and ext4_buddy struct=
s.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>
> Hey Amir,
>
> What sort of testing have you done with this patch series? =A0In
> particular, have you tried doing online resizes while the file system
> is heavily loaded?

I have tested many small resizes, not block group aligned and added
debug prints in mballoc.c to verify that in-memory bb_free and group_de=
sc
bg_free_blocks remain in sync.

Sorry, I did not run the same tests under heavy load.
I would think that one would need to know exactly how to load his
system to make that load relevant to this test, rather than blindly
fsstressing the system.
If you have specific ideas for testing please let us know.
I think Yongqiang could run these tests.

Regarding the "risk" of online resize with this patch,
if you look at ext4_add_groupblocks() in it's new form,
you will surely notice that it is an exact replica of ext4_free_blocks(=
)
with lots of irrelevant code removed, so the code path of online resize=
,
is essentially the same as the code patch of freeing any range of block=
s
with regards to buddy cache init and locks.

It was actually possible to alter ext4_free_blocks() a bit and reuse it
to do most of the work done by ext4_add_groupblocks(), but I did not
want to make these changes to ext4_free_blocks(). it's your call if
you think that would be better off.

Anyway, I was kind of hoping for another pair of eyes to validate my ch=
anges
when I first posted these patches. So what do you say?
Does the core change to synchronize ext4_mb_init_group() by locking
the buddy pages look reasonable to you?
You were the one who suggested that approach in the first place.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
