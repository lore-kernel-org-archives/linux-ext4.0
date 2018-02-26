From: Jan Kara <jack@suse.cz>
Subject: Re: v4.16-rc2: virtio-block + ext4 lockdep splats / sleeping from
	invalid context
Date: Mon, 26 Feb 2018 13:44:55 +0100
Message-ID: <20180226124455.rkp3xfn3cqplzh4p@quack2.suse.cz>
References: <20180223154735.x4ezmpjbjm6o6duw@lakrids.cambridge.arm.com>
	<20180226105256.jagidoki6vsrvzb4@quack2.suse.cz>
	<20180226113818.v544mmjsavc4x5q2@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-block@vger.kernel.org, Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180226113818.v544mmjsavc4x5q2@lakrids.cambridge.arm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-ext4.vger.kernel.org

On Mon 26-02-18 11:38:19, Mark Rutland wrote:
> On Mon, Feb 26, 2018 at 11:52:56AM +0100, Jan Kara wrote:
> > On Fri 23-02-18 15:47:36, Mark Rutland wrote:
> > > Hi all,
> > > 
> > > While fuzzing arm64/v4.16-rc2 with syzkaller, I simultaneously hit a
> > > number of splats in the block layer:
> > > 
> > > * inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage in
> > >   jbd2_trans_will_send_data_barrier
> > > 
> > > * BUG: sleeping function called from invalid context at mm/mempool.c:320
> > > 
> > > * WARNING: CPU: 0 PID: 0 at block/blk.h:297 generic_make_request_checks+0x670/0x750
> > > 
> > > ... I've included the full splats at the end of the mail.
> > > 
> > > These all happen in the context of the virtio block IRQ handler, so I
> > > wonder if this calls something that doesn't expect to be called from IRQ
> > > context. Is it valid to call blk_mq_complete_request() or
> > > blk_mq_end_request() from an IRQ handler?
> > 
> > No, it's likely a bug in detection whether IO completion should be deferred
> > to a workqueue or not. Does attached patch fix the problem? I don't see
> > exactly this being triggered by the syzkaller but it's close enough :)
> > 
> > 								Honza
> 
> That seems to be it!
> 
> With the below patch applied, I can't trigger the bug after ~10 minutes,
> whereas prior to the patch I can trigger it in ~10 seconds. I'll leave
> that running for a while just in case there's another part to the
> problem, but FWIW:
> 
> Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks for testing! Sent the patch to Jens for inclusion.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
