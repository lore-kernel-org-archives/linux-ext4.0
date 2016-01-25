From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG REPORT] NULL pointer dereference in
 jdb2_journal_grab_journal_head (RDI)
Date: Mon, 25 Jan 2016 13:30:59 +0100
Message-ID: <20160125123059.GB24938@quack.suse.cz>
References: <CAO6TR8Vhxjp-nX-wPXeBLOPmsHcb7_3y2uxk7x_V19o8hTZG0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
To: Jeff Merkey <linux.mdb@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO6TR8Vhxjp-nX-wPXeBLOPmsHcb7_3y2uxk7x_V19o8hTZG0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 23-01-16 09:42:52, Jeff Merkey wrote:
> If I leave the system in the debugger console overnight with all the
> processors suspended for about 8 hours, then type go, the following
> bug shows up during file I/O.  This particular bug showed up while
> using git to update some branches.
> 
> I have only seen this bug once and I attempted to reproduce it to get
> a trace dump but have not been able to trigger it again.  The NULL
> pointer is RDI set to NULL while trying to obtain a lock.
> 
> (2)> .z grab_journal
> ffffffffa00bb740 t jbd2_journal_grab_journal_head [jbd2]
> (2)> u ffffffffa00bb740
> jbd2|jbd2_journal_grab_journal_head:
> 0xffffffffa00bb740 0F1F440000      nop    DWORD PTR [rax+rax]=0x0
> 0xffffffffa00bb745 55              push   rbp
> 0xffffffffa00bb746 4889E5          mov    rbp,rsp
> <<<<<<<<<<<<   Crashes here with RDI set to NULL
> 0xffffffffa00bb749 F00FBA2F18      lock bts DWORD PTR [rdi]=0x0,0x18
> <<<<<<<<<<<<

Thanks for report. Ok, this means jbd2_journal_grab_journal_head() got
called with 'bh == NULL'. That is certainly wrong but unless we know a full
stack trace, it's hard to guess what went wrong.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
