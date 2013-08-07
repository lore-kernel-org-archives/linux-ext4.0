From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
Date: Wed, 7 Aug 2013 11:00:52 -0700
Message-ID: <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
 <520286A4.1020101@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:51538 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3HGSBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 14:01:13 -0400
Received: by mail-vb0-f44.google.com with SMTP id e13so2161052vbg.31
        for <linux-ext4@vger.kernel.org>; Wed, 07 Aug 2013 11:01:12 -0700 (PDT)
In-Reply-To: <520286A4.1020101@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 7, 2013 at 10:40 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 08/07/2013 06:40 AM, Jan Kara wrote:
>>   One question before I look at the patches: Why don't you use fallocate()
>> in your application? The functionality you require seems to be pretty
>> similar to it - writing to an already allocated block is usually quick.
>
> One problem I've seen is that it still costs you a fault per-page to get
> the PTEs in to a state where you can write to the memory.  MADV_WILLNEED
> will do readahead to get the page cache filled, but it still leaves the
> pages unmapped.  Those faults get expensive when you're trying to do a
> couple hundred million of them all at once.

I have grand plans to teach the kernel to use hardware dirty tracking
so that (some?) pages can be left clean and writable for long periods
of time.  This will be hard.

Even so, the second write fault to a page tends to take only a few
microseconds, while the first one often blocks in fs code.

(mmap_sem is a different story, but I see it as a separate issue.)

--Andy
