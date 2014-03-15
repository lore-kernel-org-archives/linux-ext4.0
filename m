From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] readahead.2: don't claim the call blocks until all data
 has been read
Date: Sat, 15 Mar 2014 13:31:02 +0100
Message-ID: <CAKgNAkgGZ-3U8PLKrZZ5KUWMmopd1B777_6ekva5ZpeXecEZ1g@mail.gmail.com>
References: <1394812471-9693-1-git-send-email-psusi@ubuntu.com>
 <532417CA.1040300@gmail.com> <20140315092455.GA6018@infradead.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Phillip Susi <psusi@ubuntu.com>,
	linux-man <linux-man@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	linux-ext4@vger.kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
	"Gregory P. Smith" <gps@google.com>,
	Zhu Yanhai <zhu.yanhai@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39376 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaCOMbX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2014 08:31:23 -0400
In-Reply-To: <20140315092455.GA6018@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 15, 2014 at 10:24 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Mar 15, 2014 at 10:05:14AM +0100, Michael Kerrisk (man-pages) wrote:
>>        However, it may block while  it  reads
>>        the  filesystem metadata needed to locate the requested blocks.
>>        This occurs frequently with ext[234] on large files using indi???
>>        rect  blocks instead of extents, giving the appearence that the
>>        call blocks until the requested data has been read.
>>
>> Okay?
>
> The part above is something that should be in the BUGS section.

Good call. Done. Thanks, Christoph.

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
