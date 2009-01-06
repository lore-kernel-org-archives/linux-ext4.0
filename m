From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] add releasepage hooks to block devices which can
 be used by file systems
Date: Tue, 06 Jan 2009 13:07:27 +0900
Message-ID: <4962D8FF.2000409@jp.fujitsu.com>
References: <20081226050138.GU28946@ZenIV.linux.org.uk> <1230995358-24013-1-git-send-email-tytso@mit.edu> <1230995358-24013-2-git-send-email-tytso@mit.edu> <4961C1C8.2080300@jp.fujitsu.com> <20090105160514.GA8939@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090105160514.GA8939@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted-san,

Theodore Tso wrote:
 > On Mon, Jan 05, 2009 at 05:16:08PM +0900, Toshiyuki Okajima wrote:
 > > >
 > > > I was confirming whether the kernel to which your new patch is
 > > > applied can run without trouble. But unfortunately, I got a hangup
 > > > problem. Now I am investigating the root cause.  After I
 > > > investigated it for a little time, I think calling log_wait_commit()
 > > > from journal_try_to_free_buffers() can cause it.
 >
 > Sounds like a deadlock caused by the fact that we're no longer masking
 > __GFP_WAIT, probably on journal->j_wait_done_commit.  Presumably the
 > system came under pressure during a commit operation, which makes
 > sense, and so we ended up with a deadlock between kjournald and
 > kswapd.  The fix is pretty simple; we just need to mask out the
 > __GFP_WAIT in the filesystem-specific callback, since this is a
 > restriction imposed by the filesystem's use of the jbd/jbd2 layer.

Your opinion is correct.
A detailed investigation is done, and the root cause has been understood.

The deadlock was caused by the following two processes:

(1) A certain process
Memory collecting process which is started by a memory allocator calls
journal_try_to_free_buffers(). And then it calls log_wait_commit() to get more
memory and waits for the finish of one committing transaction.

(2) kjournald process
kjournald process starts by Process (1) calling log_wait_commit().
And then it calls journal_commit_transaction to write all data buffers
into the filesystem and write all metadata buffers into the journal storage.
Writing metadata buffer is journal_write_metadata_buffer(). This function also needs
new buffer_head (more memory) in order to copy a buffer_head.

Detailed Information:
Process (1):
crash> bt 260
PID: 260    TASK: f71076d0  CPU: 1   COMMAND: "kswapd0"
  #0 [f707dcbc] schedule at c06346a3
  #1 [f707dd34] log_wait_commit at f80904c1
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ -> It lets kjournald start
                                                and waits for the commit.
  #2 [f707dd70] journal_try_to_free_buffers at f808c81f
  #3 [f707dd94] blkdev_releasepage at c04916cc
  #4 [f707dda4] try_to_release_page at c04526b1
  #5 [f707ddb0] shrink_page_list at c045b3d1
  #6 [f707de50] shrink_list at c045b72e
  #7 [f707def0] shrink_zone at c045bbc6
  #8 [f707df40] kswapd at c045c12c
  #9 [f707dfd8] kthread at c043612c
#10 [f707dfe4] kernel_thread_helper at c04045e1

journal structure: 0xccab1e00

Process (2) [kjournald]:
PID: 3170   TASK: f717b240  CPU: 1   COMMAND: "kjournald"
  #0 [c42b4cf4] schedule at c06346a3
  #1 [c42b4d6c] schedule_timeout at c06349ef
  #2 [c42b4d90] io_schedule_timeout at c0633e0f
  #3 [c42b4da0] congestion_wait at c045d7ee
  #4 [c42b4dc8] try_to_free_pages at c045c82a
  #5 [c42b4e2c] __alloc_pages_internal at c04579fc
  #6 [c42b4e70] cache_alloc_refill at c0471235
  #7 [c42b4ec0] kmem_cache_alloc at c0470fa8
  #8 [c42b4ed4] alloc_buffer_head at c048c06b
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-> It tries to get a buffer but
                                               cannot get one. Because memory
                                               collectors (include: process (1))
                                               cannot go farther.
  #9 [c42b4edc] journal_write_metadata_buffer at f8090eb6
#10 [c42b4f10] journal_commit_transaction at f808df80
#11 [c42b4f98] kjournald at f809089d
#12 [c42b4fd8] kthread at c043612c
#13 [c42b4fe4] kernel_thread_helper at c04045e1

journal structure: 0xccab1e00

Additional Information:
The process by which the trigger of a deadlock is pulled is not only kswapd.
[1]
PID: 1800   TASK: f7379b60  CPU: 1   COMMAND: "rsyslogd"
  #0 [f61c3bfc] schedule at c06346a3
  #1 [f61c3c74] log_wait_commit at f80904c1
  #2 [f61c3cb0] journal_try_to_free_buffers at f808c81f
  #3 [f61c3cd4] blkdev_releasepage at c04916cc
  #4 [f61c3ce4] try_to_release_page at c04526b1
  #5 [f61c3cf0] shrink_page_list at c045b3d1
  #6 [f61c3d90] shrink_list at c045b72e
  #7 [f61c3e30] shrink_zone at c045bbc6
  #8 [f61c3e80] try_to_free_pages at c045c787
  #9 [f61c3ee4] __alloc_pages_internal at c04579fc
#10 [f61c3f28] __get_free_pages at c0457bac
#11 [f61c3f30] copy_process at c0425823
#12 [f61c3f68] do_fork at c042674b
#13 [f61c3fa4] sys_clone at c0402399
#14 [f61c3fb4] system_call at c0403893
     EAX: ffffffda  EBX: 003d0f00  ECX: b7fcd4b4  EDX: b7fcdbd8
     DS:  007b      ESI: b6fcb16c  ES:  007b      EDI: b7fcdbd8
     SS:  007b      ESP: b6fcb100  EBP: b6fcb198
     CS:  0073      EIP: 00d271f8  ERR: 00000078  EFLAGS: 00000296

[2]
PID: 1990   TASK: f70c6000  CPU: 0   COMMAND: "pcscd"
  #0 [f6078be0] schedule at c06346a3
  #1 [f6078c58] log_wait_commit at f80904c1
  #2 [f6078c94] journal_try_to_free_buffers at f808c81f
  #3 [f6078cb8] blkdev_releasepage at c04916cc
  #4 [f6078cc8] try_to_release_page at c04526b1
  #5 [f6078cd4] shrink_page_list at c045b3d1
  #6 [f6078d74] shrink_list at c045b72e
  #7 [f6078e14] shrink_zone at c045bbc6
  #8 [f6078e64] try_to_free_pages at c045c787
  #9 [f6078ec8] __alloc_pages_internal at c04579fc
#10 [f6078f0c] cache_alloc_refill at c0471235
#11 [f6078f5c] kmem_cache_alloc at c0470fa8
#12 [f6078f70] getname at c047b71c
#13 [f6078f88] do_sys_open at c04729d2
#14 [f6078fa0] sys_open at c0472ab6
#15 [f6078fb4] ia32_sysenter_target at c04037da
     EAX: 00000005  EBX: 006a2700  ECX: 00098800  EDX: 00000000
     DS:  007b      ESI: 006a2700  ES:  007b      EDI: 00000000
     SS:  007b      ESP: b801d0f8  EBP: b801d188
     CS:  0073      EIP: b803f424  ERR: 00000005  EFLAGS: 00000202
...

Regards,
Toshiyuki Okajima

