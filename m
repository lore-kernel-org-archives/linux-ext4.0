From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 00/35 v1] pagevec API cleanups
Date: Thu, 1 Jun 2017 04:36:04 -0700
Message-ID: <20170601113604.GA10829@infradead.org>
References: <20170601093245.29238-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, cluster-devel@redhat.com,
	linux-nilfs@vger.kernel.org, tytso@mit.edu,
	linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>,
	David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org,
	Nadia Yvette Chambers <nyc@holomorphy.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
	linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 01, 2017 at 11:32:10AM +0200, Jan Kara wrote:
> * Implement ranged variants for pagevec_lookup and find_get_ functions. Lot
>   of callers actually want a ranged lookup and we unnecessarily opencode this
>   in lot of them.

How does this compare to Kents page cache iterators:

http://www.spinics.net/lists/linux-mm/msg104737.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
