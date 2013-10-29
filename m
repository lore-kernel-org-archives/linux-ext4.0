From: Jan Kara <jack@suse.cz>
Subject: Re: process hangs in ext4_sync_file
Date: Tue, 29 Oct 2013 16:26:29 +0100
Message-ID: <20131029152629.GB5065@quack.suse.cz>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
 <20131023102042.GE1275@quack.suse.cz>
 <CAEfL3KnUhETAWeh-OoRYTR5GxYL26TjaT=j_WDZeW5xa3vAdeg@mail.gmail.com>
 <CAEfL3KmAXw+mE24kZkG4YHU3C98rU6pkbAwMhSO1pw1rg81HVw@mail.gmail.com>
 <20131029144649.GB1890@quack.suse.cz>
 <CAEfL3KkD--XuvNasp_5qLrNiY11NsRuWPF5ufw3mN_VvQ5aMQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Sandeep Joshi <sanjos100@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3J2P0c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Oct 2013 11:26:32 -0400
Content-Disposition: inline
In-Reply-To: <CAEfL3KkD--XuvNasp_5qLrNiY11NsRuWPF5ufw3mN_VvQ5aMQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 29-10-13 20:30:19, Sandeep Joshi wrote:
> On Tue, Oct 29, 2013 at 8:16 PM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 29-10-13 11:00:25, Sandeep Joshi wrote:
> >> On Wed, Oct 23, 2013 at 8:28 PM, Sandeep Joshi <sanjos100@gmail.com> wrote:
> >> > On Wed, Oct 23, 2013 at 3:50 PM, Jan Kara <jack@suse.cz> wrote:
> >> > > On Mon 21-10-13 18:09:02, Sandeep Joshi wrote:
> >> > >> I am seeing a problem reported 4 years earlier
> >> > >> https://lkml.org/lkml/2009/3/12/226
> >> > >> (same stack as seen by Alexander)
> >> > >>
> >> > >> The problem is reproducible.  Let me know if you need any info in
> >> > >> addition to that seen below.
> >> > >>
> >> > >> I have multiple threads in a process doing heavy IO on a ext4
> >> > >> filesystem mounted with (discard, noatime) on a SSD or HDD.
> >> > >>
> >> > >> This is on Linux 3.8.0-29-generic #42~precise1-Ubuntu SMP Wed Aug 14
> >> > >> 16:19:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> >> > >>
> >> > >> For upto minutes at a time, one of the threads seems to hang in sync to
> >> > disk.
> >> > >>
> >> > >> When I check the thread stack in /proc, I find that the stack is one
> >> > >> of the following two
> >> > >>
> >> > >> <ffffffff81134a4e>] sleep_on_page+0xe/0x20
> >> > >> [<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
> >> > >> [<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
> >> > >> [<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
> >> > >> [<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
> >> > >> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
> >> > >> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
> >> > >> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
> >> > >> [<ffffffffffffffff>] 0xffffffffffffffff
> >> > >>
> >> > >>
> >> > >> OR
> >> > >>
> >> > >>
> >> > >> [<ffffffff812947f5>] jbd2_log_wait_commit+0xb5/0x130
> >> > >> [<ffffffff81297213>] jbd2_complete_transaction+0x53/0x90
> >> > >> [<ffffffff81236bcd>] ext4_sync_file+0x1ed/0x2b0
> >> > >> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
> >> > >> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
> >> > >> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
> >> > >> [<ffffffffffffffff>] 0xffffffffffffffff
> >> > >>
> >> > >> Any clues?
> >> > >   We are waiting for IO to complete. As the first thing, try to remount
> >> > > your filesystem without 'discard' mount option. That is often causing
> >> > > problems.
> >> > >
> >> > >                                                                 Honza
> >> >
> >>
> >>
> >> Update : I removed the "discard" option as suggested and I dont see
> >> processes hanging in ext4_sync_file anymore.   I also tried ext2 and no
> >> problems there either.
> >>
> >> So isn't the "discard' option recommended for SSDs?   Is this a known
> >> problem with ext4?
> >   No, it isn't really recommended for ordinary SSDs. If you have one of
> > those fancy PCIe attached SSDs, 'discard' option might be useful for you
> > but for usual SATA attached ones it's usually a disaster. There you might
> > be better off running 'fstrim' command once a week or something like that.
> 
> Could you briefly point out what problematic code paths come into play
> when the "discard" option is enabled?    I want to read the code to
> understand the problem better.
  After a transaction commit is done, we send 'DISCARD' command for all
blocks that were released in the committed transaction. You won't see much
interesting there. It's just that with SATA attached SSDs the 'DISCARD'
command is rather slow and we will send quite a few of them.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
