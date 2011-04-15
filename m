From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH V8 4/8] mm/fs: add hooks to support cleancache
Date: Sat, 16 Apr 2011 00:37:36 +0900
Message-ID: <871v135xvj.fsf@devron.myhome.or.jp>
References: <83ef8b69-f041-43e6-a5a9-880ff3da26f2@default>
	<20110415081054.79a164d3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
	adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com,
	jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org,
	jeremy@goop.org, JBeulich@novell.com,
	Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
	Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
	avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>,
	mel@csn.ul.ie, yinghan@google.com, gthelen@google.com,
	torvalds@linux-foundation.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:35410 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1DOPh7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2011 11:37:59 -0400
In-Reply-To: <20110415081054.79a164d3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 15 Apr 2011 08:10:54 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton <akpm@linux-foundation.org> writes:

>> > Before I suggested a thing about cleancache_flush_page,
>> > cleancache_flush_inode.
>> > 
>> > what's the meaning of flush's semantic?
>> > I thought it means invalidation.
>> > AFAIC, how about change flush with invalidate?
>> 
>> I'm not sure the words "flush" and "invalidate" are defined
>> precisely or used consistently everywhere in computer
>> science, but I think that "invalidate" is to destroy
>> a "pointer" to some data, but not necessarily destroy the
>> data itself.   And "flush" means to actually remove
>> the data.  So one would "invalidate a mapping" but one
>> would "flush a cache".
>> 
>> Since cleancache_flush_page and cleancache_flush_inode
>> semantically remove data from cleancache, I think flush
>> is a better name than invalidate.
>> 
>> Does that make sense?
>> 
>
> nope ;)
>
> Kernel code freely uses "flush" to refer to both invalidation and to
> writeback, sometimes in confusing ways.  In this case,
> cleancache_flush_inode and cleancache_flush_page rather sound like they
> might write those things to backing store.  

I'd like to mention about *_{get,put}_page too. In linux get/put is not
meaning read/write. There is {get,put}_page those are refcount stuff
(Yeah, and I felt those methods does refcount by quick read. But it
seems to be false. There is no xen codes, so I don't know actually
though.).

And I agree, I also think the needing thing is consistency on the linux
codes (term).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
