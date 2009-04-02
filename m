From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Thu, 2 Apr 2009 22:24:29 +1100
Message-ID: <200904022224.31060.nickpiggin@yahoo.com.au>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324173511.GJ23439@duck.suse.cz> <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
	linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
	Alex Khesin <alexk@google.com>,
	Mike Waychison <mikew@google.com>,
	Rohit Seth <rohitseth@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ying Han <yinghan@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21299 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751218AbZDBLYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 07:24:38 -0400
In-Reply-To: <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 02 April 2009 09:36:13 Ying Han wrote:
> Hi Jan:
>     I feel that the problem you saw is kind of differnt than mine. As
> you mentioned that you saw the PageError() message, which i don't see
> it on my system. I tried you patch(based on 2.6.21) on my system and
> it runs ok for 2 days, Still, since i don't see the same error message
> as you saw, i am not convineced this is the root cause at least for
> our problem. I am still looking into it.
>     So, are you seeing the PageError() every time the problem happened?

So I asked if you could test with my workaround of taking truncate_mutex
at the start of ext2_get_blocks, and report back. I never heard of any
response after that.

To reiterate: I was able to reproduce a problem with ext2 (I was testing
on brd to get IO rates high enough to reproduce it quite frequently).
I think I narrowed the problem down to block allocation or inode block
tree corruption because I was unable to reproduce it with that hack in
place.

