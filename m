Return-Path: <SRS0=PkuD=NH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35338 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbeJ0WVI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 Oct 2018 18:21:08 -0400
Date: Sat, 27 Oct 2018 09:40:01 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: syzbot <syzbot+b620151161795bd74a60@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in ext4_map_blocks
Message-ID: <20181027134001.GB29237@thunk.org>
References: <000000000000dd0a16057933e7d6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dd0a16057933e7d6@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

#syz dup: general protection fault in rb_erase

The fix for this is already in Linux's tree (merged on October 24th).
