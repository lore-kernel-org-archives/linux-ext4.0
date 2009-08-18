From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Questions on ext4 and writeback
Date: Tue, 18 Aug 2009 09:57:49 -0700
Message-ID: <6601abe90908180957u6ebe424q878229d2df9ffa94@mail.gmail.com>
References: <6601abe90908130909v582df37aq773e95f49f4a1248@mail.gmail.com>
	 <20090818163909.GD28560@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:30499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZHRQ5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 12:57:53 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n7IGvqG7013754
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 17:57:53 +0100
Received: from pxi9 (pxi9.prod.google.com [10.243.27.9])
	by zps36.corp.google.com with ESMTP id n7IGvnhW031136
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 09:57:50 -0700
Received: by pxi9 with SMTP id 9so40709pxi.0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 09:57:49 -0700 (PDT)
In-Reply-To: <20090818163909.GD28560@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Tue, Aug 18, 2009 at 9:39 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Thu, Aug 13, 2009 at 09:09:58AM -0700, Curt Wohlgemuth wrote:
>> But the actual submittal of I/O for the previous extent might cause
>> pages_skipped to be bumped, right? =A0Removing these increments migh=
t cause
>> the accounting to be incorrect, it seems to me.
>
> I don't see where the submission of an extent of pages for I/O would
> cause page_skipped to be incremented or changed --- am I missing
> something?

Probably not.  But it seems to me that a call order of

  write_cache_pages -> __mpage_da_writepage -> mpage_da_submit_io ->
ext4_writepage

can cause pages_skipped to be incremented, either directly in
ext4_writepage() (page has delayed/unwritted buffers) or in
__block_write_full_page() (buffer already locked).

In fact, in mpage_da_submit_io(), pages_written is only incremented if
pages_skipped hasn't been bumped -- so that routine already knows that
pages_skipped might be changed on I/O submit.

If this happens, ext4_da_writepages() will wipe out the fact that
pages_skipped was changed during submittal, won't it?

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
