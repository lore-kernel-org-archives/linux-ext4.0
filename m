Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37488 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbeJBVhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Oct 2018 17:37:14 -0400
Date: Tue, 2 Oct 2018 10:53:22 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: syzbot <syzbot+0e7e90fff14568b11ebe@syzkaller.appspotmail.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in jbd2_journal_commit_transaction
Message-ID: <20181002145322.GE17537@thunk.org>
References: <000000000000314dab05769dd5b6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000314dab05769dd5b6@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 06:19:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    46c163a036b4 Add linux-next specific files for 20180921
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1283fef1400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20ea07a946ad19d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e7e90fff14568b11ebe
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d6792a400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1610b21a400000

#syz dup: INFO: task hung in ext4_fallocate
