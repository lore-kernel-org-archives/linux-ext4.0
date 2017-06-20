From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 28/28] quota: add extra inode count to dquot transfer functions
Date: Tue, 20 Jun 2017 02:53:22 -0700
Message-ID: <CAAeU0aMPZdG9r-en9qKLHcYwPbm-4=uTrZunXngj9WztCCoPgQ@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531081517.11438-28-tahsin@google.com>
 <20170615075735.GB1764@quack2.suse.cz> <CAAeU0aNgon_ERWyUNmAGaBCuk3dU9qAxA7QnZ4D8cb5g6JZcPg@mail.gmail.com>
 <20170619090329.GE11837@quack2.suse.cz> <CAAeU0aM=QDb-iCnr5KVatQmmbQy8A7XmbyFBttK72SGt3oNTUg@mail.gmail.com>
 <20170619123614.GA20405@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:35855 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdFTJxX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jun 2017 05:53:23 -0400
Received: by mail-yb0-f177.google.com with SMTP id t7so35526983yba.3
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jun 2017 02:53:23 -0700 (PDT)
In-Reply-To: <20170619123614.GA20405@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 19, 2017 at 5:36 AM, Jan Kara <jack@suse.cz> wrote:
> Heh, this "pushing of responsibility" looks like a silly game. If an error
> can happen in a function, it is better to report it as far as easily
> possible (unless we can cleanly handle it which we cannot here). I'm guilty
> of making dquot_free_inode() ignore errors from mark_all_dquot_dirty() and
> in retrospect it would have been better if these were propagated to the
> caller as well. And eventually we can fix this if we decide we care enough.
> I'm completely fine with just returning an error from dquot_free_inode()
> and ignore it in all the callers except for ext4. Then filesystems which
> care enough can try to handle the error. That way we at least don't
> increase the design debt from the past.

I sent an update but since patch title changed it landed in a new
email thread I think ("[PATCH v2 28/31] quota: add get_inode_usage
callback to transfer multi-inode charges"). I will respond to your
comment in that thread.
