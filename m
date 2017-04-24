From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 06/20] dax: set errors in mapping
	when writeback fails
Date: Mon, 24 Apr 2017 08:24:06 -0700
Message-ID: <20170424152406.GF9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com>
	<20170424132259.8680-7-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jfs-discussion@lists.sourceforge.net, neilb@suse.de, dhowells@redhat.com,
	linux-mm@kvack.org, linux-cifs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, corbet@lwn.net,
	cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, osd-dev@open-osd.org,
	axboe@kernel.dk, tytso@mit.edu, clm@fb.com,
	mawilcox@microsoft.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk
To: Jeff Layton <jlayton@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-7-jlayton@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
