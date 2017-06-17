From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 28/28] quota: add extra inode count to dquot transfer functions
Date: Fri, 16 Jun 2017 18:50:58 -0700
Message-ID: <CAAeU0aNgon_ERWyUNmAGaBCuk3dU9qAxA7QnZ4D8cb5g6JZcPg@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531081517.11438-28-tahsin@google.com>
 <20170615075735.GB1764@quack2.suse.cz>
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
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35843 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752391AbdFQBvA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jun 2017 21:51:00 -0400
Received: by mail-yw0-f180.google.com with SMTP id l75so25919470ywc.3
        for <linux-ext4@vger.kernel.org>; Fri, 16 Jun 2017 18:51:00 -0700 (PDT)
In-Reply-To: <20170615075735.GB1764@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 15, 2017 at 12:57 AM, Jan Kara <jack@suse.cz> wrote:
> Hum, rather handle this similarly to how we handle delalloc reserved space.
> Add a callback to dq_ops to get "inode usage" of an inode and then use it
> in dquot_transfer(), dquot_free_inode(), dquot_alloc_inode().

I tried that approach by adding a "int get_inode_usage(struct inode
*inode, qsize_t *usage)" callback to dquot_operations. Unfortunately,
ext4 code that calculates the number of internal inodes
(ext4_xattr_inode_count()) is subject to failures so the callback has
to be able to report errors. And, that itself is problematic because
we can't afford to have errors in dquot_free_inode(). If you have
thoughts about how to address this please let me know.

Alternatively, I could try to make this patch less intrusive by
keeping the existing dquot_transfer() signature and add a new
dquot_transfer_usage() that accepts inode_usage as a parameter. What
do you think?
