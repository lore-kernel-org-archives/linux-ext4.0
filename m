From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Date: Wed, 19 Sep 2007 19:15:46 +0100
Message-ID: <20070919181546.GA4343@shadowen.org>
References: <20070911124202.GI9556@shadowen.org> <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org> <20070911173049.GA10499@shadowen.org> <20070914094905.GA32670@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	mel@csn.ul.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761823AbXISSQW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070914094905.GA32670@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 14, 2007 at 10:49:05AM +0100, Andy Whitcroft wrote:
> On Tue, Sep 11, 2007 at 06:30:49PM +0100, Andy Whitcroft wrote:
> > Annoyingly this seems to be intermittent, and I have not managed to get
> > a machine into this state again yet.  Will keep trying.
> 
> Ok, I have been completly unsuccessful in reproducing this.  Dispite
> having two distinct machines showing this behaviour.  I have neither
> been able to reproduce it with those machine on 2.6.23-rc6 nor has any
> of the testing of any of the -git releases which follow thrown this
> error.  I have run about 10 repeats of the jobs which failed too and
> none of those have thrown the same error.
> 
> It is pretty clear from the dbench output that the problem is/was real,
> that its not some artifact of the test harness.  I am a loss as to how to
> get this to trigger again.
> 
> I guess I will keep monitoring the ongoing tests for new instances.  I
> will also look to getting the sysrq-* stuff triggered automatically on
> job timeout as that seems like a sane plan in all cases.
> 
> Frustrated.

I have since had a single occurance of a hang on 2.6.23-rc6-mm1.  As the
base is different I cannot for sure say its the same problem.  In this
new event we had a mkfs hung in a 'D' wait:

 =======================
mkfs.ext2     D c10220f4     0  6233   6222
       c344fc80 00000082 00000286 c10220f4 c344fc90 002ed099 c2963340 c2b9f640
       c142bce0 c2b9f640 c344fc90 002ed099 c344fcfc c344fcc0 c1219563 c1109bf2
       c344fcc4 c186e4d4 c186e4d4 002ed099 c1022612 c2b9f640 c186e000 c104000c
Call Trace:
 [<c10220f4>] lock_timer_base+0x19/0x35
 [<c1219563>] schedule_timeout+0x70/0x8d
 [<c1109bf2>] prop_fraction_single+0x37/0x5d
 [<c1022612>] process_timeout+0x0/0x5
 [<c104000c>] task_dirty_limit+0x3a/0xb5
 [<c12194da>] io_schedule_timeout+0x1e/0x28
 [<c10454b4>] congestion_wait+0x62/0x7a
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c10402af>] get_dirty_limits+0x16a/0x172
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c104040b>] balance_dirty_pages+0x154/0x1be
 [<c103bda3>] generic_perform_write+0x168/0x18a
 [<c103be38>] generic_file_buffered_write+0x73/0x107
 [<c103c346>] __generic_file_aio_write_nolock+0x47a/0x4a5
 [<c11b0fef>] do_sock_write+0x92/0x99
 [<c11b1048>] sock_aio_write+0x52/0x5e
 [<c103c3b9>] generic_file_aio_write_nolock+0x48/0x9b
 [<c105d2d6>] do_sync_write+0xbf/0xfc
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c1010311>] do_page_fault+0x2cc/0x739
 [<c105d3a0>] vfs_write+0x8d/0x108
 [<c105d4c3>] sys_write+0x41/0x67
 [<c100260a>] syscall_call+0x7/0xb
 =======================

-apw
