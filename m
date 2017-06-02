From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 27/28] ext4: xattr inode deduplication
Date: Fri, 2 Jun 2017 10:59:35 -0700
Message-ID: <20170602175935.GB5626@birch.djwong.org>
References: <20170531160004.GG4510@birch.djwong.org>
	<20170531223357.800-1-tahsin@google.com>
	<20170602054143.GA5626@birch.djwong.org>
	<CAAeU0aN+Ts=SqGFEMOer=rguprDNX4Mo1Eyj+j1Y=dd-zdbkZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <CAAeU0aN+Ts=SqGFEMOer=rguprDNX4Mo1Eyj+j1Y=dd-zdbkZw@mail.gmail.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 02, 2017 at 05:46:22AM -0700, Tahsin Erdogan wrote:
> > Hmm... normally we'd supply sbi->s_csum_seed as the second argument so
> > that the metadata checksum value also has the fs uuid stamped into it.
> 
> I have thought about using sbi->s_csum_seed and was a little hesitant
> because it involves adding more complexity to e2fsprogs to handle
> cases like changing uuid or turning off metadata_csum. After thinking
> more about this, I think it is doable.

e2fsprogs already has code to walk the fs to rewrite/remove checksums,
so it shouldn't be too much effort to tap into that to rewrite the
ea_info hash.

> > Even if you dismiss that, we usually follow the convention of
> > initializing the crc32c calculation with (~0U), not (0U), to strengthen
> > crc32c's ability to detect zeroes being injected at the start of the
> > stream.
> 
> Agreed, using ~0 is definitely better than 0.

--D
