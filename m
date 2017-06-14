From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 29/31] ext4: reserve space for xattr entries/names
Date: Wed, 14 Jun 2017 16:39:37 -0700
Message-ID: <CAAeU0aPBotudmaexDh60tBZUcFYk5ZDE2S9byMdD+u1Q34AXnA@mail.gmail.com>
References: <20170614172326.18670-1-tahsin@google.com> <20170614230518.GA4518@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170614230518.GA4518@birch.djwong.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 14, 2017 at 4:05 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> Why not just spill the values into their own ea_inodes if we need the
> space?  I guess that has the disadvantage that now we need to reserve
> quite a few more journal credits ((1 inode block, 1 bbitmap block, 1
> ibitmap block, 1 data block) * nr_inline_values) just in case we end up
> spilling all the values.
>

In last week's ext4 conference call we have discussed this problem and
possible solutions. The major concern with spilling/evacuation
approach was the added complexity. We haven't discussed the impact on
journal credits, but that is a valid point too.
