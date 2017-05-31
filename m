From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 07/28] ext4: call journal revoke when freeing ea_inode blocks
Date: Wed, 31 May 2017 14:01:26 -0700
Message-ID: <CAAeU0aNS-xT4rNPKrO7kG5dLep+xqbVFGRWw8NaiXBbAYf1-=w@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531081517.11438-7-tahsin@google.com>
 <20170531161257.GI4510@birch.djwong.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531161257.GI4510@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I think it would be wise not to support !extents && ea_inode,
> particularly since blockmaps aren't protected by metadata_csum and so in
> the long run it's probably best to minimize the introduction of new
> blockmap files (on ext4 anyway).

Sounds good. I will add that to e2fsprogs patches. thanks
