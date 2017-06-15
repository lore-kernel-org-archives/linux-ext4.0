From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 23/28] mbcache: make mbcache more generic
Date: Thu, 15 Jun 2017 11:25:02 -0700
Message-ID: <CAAeU0aMLrfhnhqzD9PH2UjHSrc64AC_85rAEz626jcuFjLXY2g@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531081517.11438-23-tahsin@google.com>
 <20170615074158.GA1764@quack2.suse.cz>
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
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36155 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdFOSZE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Jun 2017 14:25:04 -0400
Received: by mail-yw0-f170.google.com with SMTP id l75so10534044ywc.3
        for <linux-ext4@vger.kernel.org>; Thu, 15 Jun 2017 11:25:04 -0700 (PDT)
In-Reply-To: <20170615074158.GA1764@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 15, 2017 at 12:41 AM, Jan Kara <jack@suse.cz> wrote:
> Can you explain a bit more what do you mean by "make it more generic" as it
> seems you just rename a couple of things here...

The change is really just that, having names that are more generic
which do not limit use cases to block sharing. In a subsequent patch
in the series ("[PATCH v4 27/28] ext4: xattr inode deduplication"), we
start using the mbcache code to share xattr inodes. With that patch,
old mb_cache_entry.e_block field could be holding either a block
number or an inode number, so I renamed things to make them more
generic.
