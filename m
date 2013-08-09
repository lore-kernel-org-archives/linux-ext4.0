From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
Date: Thu, 8 Aug 2013 17:11:30 -0700
Message-ID: <CALCETrVZBpZDQ7-QjDYYQyGGtCEAk-ydb0DUUA9gcFtj4JYv6w@mail.gmail.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
 <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com>
 <20130808101807.GB4325@quack.suse.cz> <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com>
 <20130808185340.GA13926@quack.suse.cz> <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38248 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966748Ab3HIALv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Aug 2013 20:11:51 -0400
Received: by mail-vc0-f177.google.com with SMTP id gf12so596967vcb.22
        for <linux-ext4@vger.kernel.org>; Thu, 08 Aug 2013 17:11:51 -0700 (PDT)
In-Reply-To: <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 8, 2013 at 12:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Whoops -- I read your email too quickly.  I haven't tried
> MADV_WILLNEED, but I think I tried reading each page to fault them in.
>  Is there any reason to expect MADV_WILLNEED to do any better?  I'll
> try to do some new tests to see how well this all works.
>
> (I imagine that freshly fallocated files are somehow different when
> read, since there aren't zeros on the disk backing them until they get
> written.)

Well, this will teach me to write code based on an old benchmark from
memory.  It seems that prefaulting for read is okay on Linux 3.9 --
latencytop isn't do_wp_page or ext4* at all, at least not for the last
couple minutes on my test box.

I wonder if ext4 changed its handling of fallocated extents somewhere
between 3.5 and 3.9.  In any case, please consider these patches
withdrawn for the time being.

* With file_update_time stubbed out.  I need to dust off my old
patches to fix that part.
