From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [KNOWN BUGGY RFC PATCH 4/3] block: skip elevator initialization
 for flush requests
Date: Tue, 25 Jan 2011 16:55:01 -0500
Message-ID: <20110125215500.GA6836@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1AYVz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 16:55:29 -0500
Content-Disposition: inline
In-Reply-To: <20110125204158.GA3013@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25 2011 at  3:41pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Tejun,
> 
> On Fri, Jan 21 2011 at 10:59am -0500,
> Tejun Heo <tj@kernel.org> wrote:
> > 
> > * As flush requests are never put on the IO scheduler, request fields
> >   used for flush share space with rq->rb_node.  rq->completion_data is
> >   moved out of the union.  This increases the request size by one
> >   pointer.
> > 
> >   As rq->elevator_private* are used only by the iosched too, it is
> >   possible to reduce the request size further.  However, to do that,
> >   we need to modify request allocation path such that iosched data is
> >   not allocated for flush requests.
> 
> I decided to take a crack at using rq->elevator_private* and came up
> with the following patch.
> 
> Unfortunately, in testing I found that flush requests that have data do
> in fact eventually get added to the queue as normal requests, via:
> 1) "data but flush is not necessary" case in blk_insert_flush
> 2) REQ_FSEQ_DATA case in blk_flush_complete_seq

Vivek helped me understand that adding the request to the queue doesn't
mean it goes to the elevator.  It is inserting the request directly to
the underlying queue.

That embarassing oversight aside, the flush request is still getting to
the elevator somehow -- even though elv_set_request() was clearly not
called.

It is an interesting duality that:
1) REQ_ELVPRIV is never set because priv=0 is passed to blk_alloc_request
2) yet when blk_free_request() checks rq->cmd_flags REQ_ELVPRIV is set;
   resulting in the call to elv_put_request()

> I know this because in my following get_request() change to _not_ call
> elv_set_request() for flush requests hit cfq_put_request()'s
> BUG_ON(!cfqq->allocated[rw]).

FYI, here is the backtrace:

PID: 0      TASK: ffff88007ccd6b30  CPU: 1   COMMAND: "swapper"
 #0 [ffff880002103930] show_trace_log_lvl at ffffffff8100f3ec
 #1 [ffff880002103980] delay_tsc at ffffffff8125e62a
 #2 [ffff8800021039b0] __const_udelay at ffffffff8125e5d6
 #3 [ffff8800021039c0] panic at ffffffff814c3604
 #4 [ffff880002103a40] oops_end at ffffffff814c7622
 #5 [ffff880002103a70] die at ffffffff8100f33b
 #6 [ffff880002103aa0] do_trap at ffffffff814c6ec4
 #7 [ffff880002103b00] do_invalid_op at ffffffff8100cee5
 #8 [ffff880002103ba0] invalid_op at ffffffff8100bf5b
    [exception RIP: cfq_put_request+128]
    RIP: ffffffff8124f000  RSP: ffff880002103c58  RFLAGS: 00010046
    RAX: 0000000000000019  RBX: ffff88007b5668a0  RCX: 0000000000002c7b
    RDX: 0000000000000000  RSI: ffff88007b5668a0  RDI: ffff88007b5668a0
    RBP: ffff880002103c68   R8: 0000000000000003   R9: 0000000000000001
    R10: 0000000000000003  R11: 0000000000000003  R12: ffff88007b566940
    R13: 00000000018c2441  R14: 0000000000000001  R15: 00000000000000a5
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff880002103c70] elv_put_request at ffffffff8123208e
#10 [ffff880002103c80] __blk_put_request at ffffffff8123ae23
#11 [ffff880002103cb0] blk_finish_request at ffffffff8123b049
#12 [ffff880002103d00] __blk_end_request_all at ffffffff8123b0fb
#13 [ffff880002103d20] blk_flush_complete_seq at ffffffff8123de4c
#14 [ffff880002103d50] flush_end_io at ffffffff8123e095
#15 [ffff880002103da0] blk_finish_request at ffffffff8123aedb
#16 [ffff880002103df0] __blk_end_request_all at ffffffff8123b0fb
#17 [ffff880002103e10] blk_done at ffffffffa002e085
#18 [ffff880002103e50] vring_interrupt at ffffffffa001f19c
#19 [ffff880002103e70] vp_vring_interrupt at ffffffffa00264bb
#20 [ffff880002103ec0] vp_interrupt at ffffffffa0026544
#21 [ffff880002103ee0] handle_IRQ_event at ffffffff810d10b0
#22 [ffff880002103f30] handle_fasteoi_irq at ffffffff810d38a9
#23 [ffff880002103f60] handle_irq at ffffffff8100dfb9
#24 [ffff880002103f80] do_IRQ at ffffffff814cb32c
--- <IRQ stack> ---
#25 [ffff88007ccf9e28] ret_from_intr at ffffffff8100bad3
    [exception RIP: native_safe_halt+11]
    RIP: ffffffff81033f0b  RSP: ffff88007ccf9ed8  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: ffff88007ccf9ed8  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff81d0f1e8
    RBP: ffffffff8100bace   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 00000000fffba7c1  R12: 0000000000000001
    R13: ffff88007ccf9e68  R14: 0000000281075d93  R15: ffff88007ccf9e98
    ORIG_RAX: ffffffffffffffc4  CS: 0010  SS: 0018
#26 [ffff88007ccf9ee0] default_idle at ffffffff81013e0d
#27 [ffff88007ccf9f00] cpu_idle at ffffffff81009e96
