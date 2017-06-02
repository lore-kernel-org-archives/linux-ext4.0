From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2 27/28] ext4: xattr inode deduplication
Date: Fri, 2 Jun 2017 05:46:22 -0700
Message-ID: <CAAeU0aN+Ts=SqGFEMOer=rguprDNX4Mo1Eyj+j1Y=dd-zdbkZw@mail.gmail.com>
References: <20170531160004.GG4510@birch.djwong.org> <20170531223357.800-1-tahsin@google.com>
 <20170602054143.GA5626@birch.djwong.org>
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
In-Reply-To: <20170602054143.GA5626@birch.djwong.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Hmm... normally we'd supply sbi->s_csum_seed as the second argument so
> that the metadata checksum value also has the fs uuid stamped into it.

I have thought about using sbi->s_csum_seed and was a little hesitant
because it involves adding more complexity to e2fsprogs to handle
cases like changing uuid or turning off metadata_csum. After thinking
more about this, I think it is doable.

> Even if you dismiss that, we usually follow the convention of
> initializing the crc32c calculation with (~0U), not (0U), to strengthen
> crc32c's ability to detect zeroes being injected at the start of the
> stream.

Agreed, using ~0 is definitely better than 0.
