From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Tue, 8 Sep 2009 14:18:35 -0700
Message-ID: <6601abe90909081418k5de55938mfe411fccfe10a258@mail.gmail.com>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com>
	 <20090908175605.GB7801@shell>
	 <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com>
	 <20090908194045.GQ22901@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Aurora <vaurora@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:28091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZIHVSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 17:18:36 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n88LIcIA010285
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 14:18:39 -0700
Received: from pzk1 (pzk1.prod.google.com [10.243.19.129])
	by spaceape10.eur.corp.google.com with ESMTP id n88LINTp004154
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 14:18:36 -0700
Received: by pzk1 with SMTP id 1so41239pzk.17
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2009 14:18:35 -0700 (PDT)
In-Reply-To: <20090908194045.GQ22901@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Tue, Sep 8, 2009 at 12:40 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Tue, Sep 08, 2009 at 11:21:11AM -0700, Curt Wohlgemuth wrote:
>> Hi Valerie:
>>
>> On Tue, Sep 8, 2009 at 10:56 AM, Valerie Aurora<vaurora@redhat.com> =
wrote:
>> > Hey, did you figure this out? =A0If not, I want to have a bug open
>> > somewhere.
>>
>> Yes, sorry. =A0I was going to post a patch for this, but have been
>> waiting to verify that it really fixes the issue. =A0And see the thr=
ead
>> started by Frank Mayhar about fsync issues as well...
>>
>> The problem is a race, between the last write to a to-be-freed
>> metadata block (to update the extent header) and the block being
>> marked free in the on-disk/buddy bitmaps. =A0Note that this only hap=
pens
>> without a journal, since *with* a journal the ordering is done
>> correctly.
>
> Just to clarify, this a race that shows up even without an unclean
> shutdown, right?

Correct.

>> Without a journal, the block buffer_head is written to, the
>> buffer_head is marked dirty, and the bitmaps are updated via
>> ext4_free_blocks(). =A0In rare cases, the block is re-allocated for
>> another inode and written to -- subsequently, the writeback mechanis=
m
>> will then flush the dirty extent header back to disk. =A0That's why =
it
>> looks like "leaked extent data" in the data block.
>
> If this shows up even without an unclean shutdown, then it sounds lik=
e
> the problem is a missing bforget() call.

I looked into this, and it may be merely my ignorance, but I don't see
how bforget() would solve the race.

All bforget() does is clear the buffer's dirty bit.  Meanwhile, the
page is still marked dirty, and can be in the middle of writeback;
it's true that __block_write_full_page() will check the dirty bit for
each buffer in the page, but there doesn't seem to be any
synchronization to ensure that the write won't take place at some
point in time after bforget() is called.  Which means it can be called
after the bitmap is changed.

This is why I opted to wait for the buffer to be written out before
continuing on to ext4_free_blocks().

Am I missing something?

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
