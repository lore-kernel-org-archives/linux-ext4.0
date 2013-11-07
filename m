From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][ext2] XIP does not work on ext2
Date: Thu, 7 Nov 2013 23:20:42 +0100
Message-ID: <20131107222042.GC2054@quack.suse.cz>
References: <CAOvWMLZ-ezykR6TkFAoZ1UW20QF6XMOKeZH8R-FdFJkXjAP9nA@mail.gmail.com>
 <20131105003733.GA24531@quack.suse.cz>
 <CAOvWMLZ6_boRgQi2L9kqR_bWcnLDHY+uFo9g4DP=zxeGtT+dag@mail.gmail.com>
 <20131105143221.GA30006@quack.suse.cz>
 <CAOvWMLY9HAeQTsEwCchKNjL+1=-grBQrDO6-KCYcS-mxMYyRpw@mail.gmail.com>
 <20131106211858.GB20477@quack.suse.cz>
 <CAOvWMLa38zOigzVkcF78ivtszd6F02aNKsB28=Sd58OMeqb9sQ@mail.gmail.com>
 <20131107210715.GA20104@quack.suse.cz>
 <CAOvWMLYXUcYUnnzPzMTJZF8iZ73a+BuC+YRePjRZhY_WtL5Jfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Wang Shilong <wangsl-fnst@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andiry Xu <andiry.xu@gmail.com>
To: Andiry Xu <andiry@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab3KGWUq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 17:20:46 -0500
Content-Disposition: inline
In-Reply-To: <CAOvWMLYXUcYUnnzPzMTJZF8iZ73a+BuC+YRePjRZhY_WtL5Jfw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-11-13 13:50:09, Andiry Xu wrote:
> On Thu, Nov 7, 2013 at 1:07 PM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 07-11-13 12:14:13, Andiry Xu wrote:
> >> On Wed, Nov 6, 2013 at 1:18 PM, Jan Kara <jack@suse.cz> wrote:
> >> > On Tue 05-11-13 17:28:35, Andiry Xu wrote:
> >> >> >> Do you know the reason why write() outperforms mmap() in some cases? I
> >> >> >> know it's not related the thread but I really appreciate if you can
> >> >> >> answer my question.
> >> >> >   Well, I'm not completely sure. mmap()ed memory always works on page-by-page
> >> >> > basis - you first access the page, it gets faulted in and you can further
> >> >> > access it. So for small (sub page size) accesses this is a win because you
> >> >> > don't have an overhead of syscall and fs write path. For accesses larger
> >> >> > than page size the overhead of syscall and some initial checks is well
> >> >> > hidden by other things. I guess write() ends up being more efficient
> >> >> > because write path taken for each page is somewhat lighter than full page
> >> >> > fault. But you'd need to look into perf data to get some hard numbers on
> >> >> > where the time is spent.
> >> >> >
> >> >>
> >> >> Thanks for the reply. However I have filled up the whole RAM disk
> >> >> before doing the test, i.e. asked the brd driver to allocate all the
> >> >> pages initially.
> >> >   Well, pages in ramdisk are always present, that's not an issue. But you
> >> > will get a page fault to map a particular physical page in process'
> >> > virtual address space when you first access that virtual address in the
> >> > mapping from the process. The cost of setting up this virtual->physical
> >> > mapping is what I'm talking about.
> >> >
> >>
> >> Yes, you are right, there are page faults observed with perf. I
> >> misunderstood page fault as copying pages between backing store and
> >> physical memory.
> >>
> >> > If you had a process which first mmaps the file and writes to all pages in
> >> > the mapping and *then* measure the cost of another round of writing to the
> >> > mapping, I would expect you should see speeds close to those of memory bus.
> >> >
> >>
> >> I've tried this as well. mmap() performance improves but still not as
> >> good as write().
> >> I used the perf report to compare write() and mmap() applications. For
> >> write() version, top of perf report shows as:
> >> 33.33%  __copy_user_nocache
> >> 4.72%    ext2_get_blocks
> >> 4.42%    mutex_unlock
> >> 3.59%    __find_get_block
> >>
> >> which looks reasonable.
> >>
> >> However, for mmap() version, the perf report looks strange:
> >> 94.98% libc-2.15.so       [.] 0x000000000014698d
> >> 2.25%   page_fault
> >> 0.18%   handle_mm_fault
> >>
> >> I don't know what the first item is but it took the majority of cycles.
> >   The first item means that it's some userspace code in libc. My guess
> > would be that it's libc's memcpy() function (or whatever you use to write
> > to mmap). How do you access the mmap?
> >
> 
> Like this:
> 
> fd = open(file_name, O_CREAT | O_RDWR | O_DIRECT, 0755);
> dest = (char *)mmap(NULL, FILE_SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
> for (i = 0; i < count; i++)
> {
>        memcpy(dest, src, request_size);
>        dest += request_size;
> }
  OK, maybe libc memcpy isn't very well optimized for you cpu? Not sure how
to tune that though...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
