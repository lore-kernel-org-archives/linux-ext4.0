From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Mon, 21 Feb 2011 22:02:44 +0200
Message-ID: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59942 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1BUUCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 15:02:45 -0500
Received: by qwd7 with SMTP id 7so2310857qwd.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 12:02:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 11:22 PM, Amir Goldstein <amir73il@gmail.com> w=
rote:
> On Mon, Feb 14, 2011 at 9:58 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
>> One thing that comes to mind about your question with the
>> e4b->alloc_semp causing problems. =A0If the only reason why we need =
it
>> is to protect against multiple attempts to initialize different bloc=
k
>> groups that share the same buddy bitmap, can we solve the problem by
>> ditching e4b->alloc_semp entirely, and simply using lock_page() on t=
he
>> buddy bitmap page to protect it?
>>
>
> Perhaps. I imagine there is more than one elegant way to deal with th=
at,
> but using a semaphore is not one of them.
> I will take a shot at evaporating e4b->alloc_semp.
>

After looking at the code a bit, I find that the only critical
resource that several
groups may share on a single page is the Uptodate flag, which is used
to indicate
that the buddy cache for *all* these groups is loaded
and lock_page() and get_page() are used to protect it.

There are 2 ways to eliminate this dependency:

1. (AKA easy lane) use a single page (or more) per block group.
this will increase the memory usage for 1K blocks fs and for 2K block f=
s
on 8K page system, but are these use cases really that common?

2. (AKA hard lane) attach buffer heads to buddy page and use
buffer_uptodate() and buffer_lock() instead of PageUptodate() and lock_=
page()
to initialize buddy cache of groups that share the same page.

What do you say?
Shall I take easy lane?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
