From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Thu, 9 May 2013 11:31:52 -0400
Message-ID: <20130509153152.GB3458@thunk.org>
References: <15102321.375241368086369792.JavaMail.weblogic@epml19>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: EUNBONG SONG <eunb.song@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47335 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3EIPb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 May 2013 11:31:56 -0400
Content-Disposition: inline
In-Reply-To: <15102321.375241368086369792.JavaMail.weblogic@epml19>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 09, 2013 at 07:59:30AM +0000, EUNBONG SONG wrote:
> 
> I got a message as below every time i ran iozone test. 
> 
> 
> [ 4876.293124] [<ffffffff80272d18>] show_stack+0x68/0x80
> [ 4876.309411] [<ffffffff802bde4c>] notifier_call_chain+0x5c/0xa8
> [ 4876.315245] [<ffffffff802be524>] __atomic_notifier_call_chain+0x3c/0x58
> [ 4876.321860] [<ffffffff802be588>] notify_die+0x38/0x48
> [ 4876.326913] [<ffffffff80272548>] do_trap_or_bp+0x48/0x1a8
> [ 4876.332312] [<ffffffff8026cfe4>] resume_userspace_check+0x0/0x10
> [ 4876.338323] [<ffffffff80462994>] jbd2_journal_put_journal_head+0xcc/0x250
> [ 4876.345111] [<ffffffff804603b4>] __jbd2_journal_remove_checkpoint+0x54/0x130
> [ 4876.352160] [<ffffffff8045e630>] jbd2_journal_commit_transaction+0x1318/0x1ad0
> [ 4876.359383] [<ffffffff80463f4c>] kjournald2+0x114/0x450
> [ 4876.364611] [<ffffffff802b8160>] kthread+0xb8/0xc0
> [ 4876.369402] [<ffffffff8026d060>] ret_from_kernel_thread+0x10/0x18
> 
> When i ran without multi-thread option, the problem was not ocurred.

Can you give us the full crash message, (i.e., the panic, the BUG,
WARN, the registers, etc.), and not the stack trace?

      	  	     	    	    - Ted
