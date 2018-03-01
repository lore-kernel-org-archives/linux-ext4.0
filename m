From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 Oops (Re: [PATCH V15 06/22] mmc: block: Add blk-mq support)
Date: Thu, 1 Mar 2018 11:04:18 -0500
Message-ID: <20180301160418.GA2490@thunk.org>
References: <1511962879-24262-1-git-send-email-adrian.hunter@intel.com>
 <1511962879-24262-7-git-send-email-adrian.hunter@intel.com>
 <bc65b542-9703-aa04-f1c7-b10584e44391@gmail.com>
 <829308a3-3bf6-c173-65fa-e2a0f45f7f61@intel.com>
 <68886f99-97f5-897a-f754-6f414741bd5a@gmail.com>
 <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
 <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
 <6a1267b0-6242-fc9f-60ed-02bf34677b62@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Osipenko <digetx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bough Chen <haibo.chen@nxp.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Mateusz Nowak <mateusz.nowak@intel.com>,
        Yuliy Izrailov <Yuliy.Izrailov@sandisk.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dong Aisheng <dongas86@gmail.com>,
        Das Asutosh <asutoshd@codeaurora.org>,
        Zhangfei Gao <zhangfei.gao@gmail.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Harjani Ritesh <riteshh@codeaurora.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Lin <shawn.lin@rock-c
To: Adrian Hunter <adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6a1267b0-6242-fc9f-60ed-02bf34677b62@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 01, 2018 at 10:55:37AM +0200, Adrian Hunter wrote:
> On 27/02/18 11:28, Adrian Hunter wrote:
> > On 26/02/18 23:48, Dmitry Osipenko wrote:
> >> But still something is wrong... I've been getting occasional EXT4 Ooops's, like
> >> the one below, and __wait_on_bit() is always figuring in the stacktrace. It
> >> never happened with blk-mq disabled, though it could be a coincidence and
> >> actually unrelated to blk-mq patches.
> > 
> >> [ 6625.992337] Unable to handle kernel NULL pointer dereference at virtual
> >> address 0000001c
> >> [ 6625.993004] pgd = 00b30c03
> >> [ 6625.993257] [0000001c] *pgd=00000000
> >> [ 6625.993594] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> >> [ 6625.994022] Modules linked in:
> >> [ 6625.994326] CPU: 1 PID: 19355 Comm: dpkg Not tainted
> >> 4.16.0-rc2-next-20180220-00095-ge9c9f5689a84-dirty #2090
> >> [ 6625.995078] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> >> [ 6625.995595] PC is aht dx_probe+0x68/0x684
> >> [ 6625.995947] LR is at __wait_on_bit+0xac/0xc8

This doesn't seem to make sense; the PC is where we are currently
executing, and LR is the "Link Register" where the flow of control
will be returning after the current function returns, right?  Well,
dx_probe should *not* be returning to __wait_on_bit().  So this just
seems.... weird.

Ignoring the LR register, this stack trace looks sane...  I can't see
which pointer could be NULL and getting dereferenced, though.  How
easily can you reproduce the problem?  Can you either (a) translate
the PC into a line number, or better yet, if you can reproduce, add a
series of BUG_ON's so we can see what's going on?

+	BUG_ON(frame);
	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
	if (IS_ERR(frame->bh))
		return (struct dx_frame *) frame->bh;

+	BUG_ON(frame->bh);
+	BUG_ON(frame->bh->b_data);
	root = (struct dx_root *) frame->bh->b_data;
	if (root->info.hash_version != DX_HASH_TEA &&
	    root->info.hash_version != DX_HASH_HALF_MD4 &&
	    root->info.hash_version != DX_HASH_LEGACY) {

These are "could never" happen scenarios from looking at the code, but
that will help explain what is going on.

If this is reliably only happening with mq, the only way I could see
that if is something is returning an error when it previously wasn't.
This isn't a problem we're seeing with any of our testing, though.

Cheers,

						- Ted
