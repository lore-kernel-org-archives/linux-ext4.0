From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 23/28] mbcache: make mbcache more generic
Date: Mon, 19 Jun 2017 10:50:26 +0200
Message-ID: <20170619085026.GD11837@quack2.suse.cz>
References: <20170531081517.11438-1-tahsin@google.com>
 <20170531081517.11438-23-tahsin@google.com>
 <20170615074158.GA1764@quack2.suse.cz>
 <CAAeU0aMLrfhnhqzD9PH2UjHSrc64AC_85rAEz626jcuFjLXY2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
        Theodore Ts'o <tytso@mit.edu>,
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
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeU0aMLrfhnhqzD9PH2UjHSrc64AC_85rAEz626jcuFjLXY2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 15-06-17 11:25:02, Tahsin Erdogan wrote:
> On Thu, Jun 15, 2017 at 12:41 AM, Jan Kara <jack@suse.cz> wrote:
> > Can you explain a bit more what do you mean by "make it more generic" as it
> > seems you just rename a couple of things here...
> 
> The change is really just that, having names that are more generic
> which do not limit use cases to block sharing. In a subsequent patch
> in the series ("[PATCH v4 27/28] ext4: xattr inode deduplication"), we
> start using the mbcache code to share xattr inodes. With that patch,
> old mb_cache_entry.e_block field could be holding either a block
> number or an inode number, so I renamed things to make them more
> generic.

OK, then I'd suggest to change title to "mbcache: make mbcache naming more
generic" and explain what you wrote here in the changelog. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
