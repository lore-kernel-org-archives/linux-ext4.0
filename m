From: Jan Kara <jack@suse.cz>
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Date: Tue, 10 Dec 2013 17:21:46 +0100
Message-ID: <20131210162146.GF1543@quack.suse.cz>
References: <20131128153420.GA21176@quack.suse.cz>
 <20131210093528.23399.qmail@science.horizon.com>
 <20131210152701.GE1543@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu, viro@ZenIV.linux.org.uk,
	linux-crypto@vger.kernel.org, x86@kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131210152701.GE1543@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-12-13 16:27:01, Jan Kara wrote:
> On Tue 10-12-13 04:35:28, George Spelvin wrote:
> > One of those additional WARN_ON tests tripped, hooray!
> > And it turned out to be in the ext4 metadata checksumming.  To be
> > precise, ext4_block_bitmap_csum_set() returned with irqs disabled,
> > and kaboom.
>   Ha, great. Thanks for the persistence in testing.
> 
> > Since I have this experimental feature turned on and most people don't,
> > this explains why I'm finding it and World+Dog aren't.
> > 
> > I appear to be the designated finder of ext4 metadata_csum bugs, so tytso
> > notified on general principles.  I dropped the generic linux-fsdevel
> > list from the Cc: list.
> > 
> > But looking at the code, it just calls into the linux-crypto layer and
> > Tim Chen's SSE CRC32C implementation which uses kernel_fpu_begin()
> > and kernel_fpu_end() if the block is large enough.
>   Yup, that code was also my last hope but I can't say I see any problem in
> there either.
  BTW, given you always see the problem when ext4_truncate() gets called 
as a response to application catching a deadly signal and thus
task_work_run() gets called, I think there's something in irq_fpu_usable()
which isn't exactly right. But I know nothing about the logic there. Or
maybe the signal is caught in some unlucky moment when FPU is in some
strange state?

								Honza

> > I was going to add and Herbert Xu and Tim Chen and all those mailing
> > lists, but looking at the code, it sure *looks* like they're Doing The
> > right Thing, so I'm holding off for a bit.
> > 
> > I'm not sure quite where to pass th buck on this one.
> > 
> > Relevant platform info:
> > - Intel i7-2700K processor, with SSE4.2 and thus the CRC32C instruction.
> > - CONFIG_PREEMPT_VOLUNTARY=y
> > - # CONFIG_PREEMPT_NONE is not set
> > - CONFIG_PREEMPT_VOLUNTARY=y
> > - # CONFIG_PREEMPT is not set
> > - CONFIG_PREEMPT_COUNT=y
> > - CONFIG_DEBUG_ATOMIC_SLEEP=y
> > - CONFIG_DEBUG_BUGVERBOSE=y
> > 
> ...
> > 
> > === Discussion ===
> > desc.shash.tfm is filled in from sbi->s_chksum_driver, which is filled in at
> > ext4_fill_super() time by crypto_alloc_shash("crc32c", 0, 0).
> > 
> > Thus, shash->update should turn into a call to crypto/crc32c.c:chksum_update(),
> > which calls lib/crc32.c:__crc32c_le().
> > 
> > Now, I happen to be running an i7-2700k which has sse4_2, and thus calls
> > into the x86 specific code, and apparently for large blocks it uses PCLMULQDQ,
> > which requires kernel_fpu_begin/end.
> > 
> > At least that makes some degree of sense.  The low level code, though
> > uses the functions in a very simple way that I can't see how it could fail
> > to unlock at the end.
>   Hum, can you try disabling the HW support of CRC32C implementation
> (CRYPTO_CRC32C_INTEL)? If the problem disappears, we know there's some
> problem in the HW support code...
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
