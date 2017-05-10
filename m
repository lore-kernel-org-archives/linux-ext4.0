From: Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH v4 23/27] gfs2: clean up some filemap_*
	calls
Date: Wed, 10 May 2017 12:18:51 -0400 (EDT)
Message-ID: <1840580824.6421109.1494433131277.JavaMail.zimbra@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
	<20170509154930.29524-24-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, neilb@suse.de, dhowells@redhat.com,
	linux-mm@kvack.org, hubcap@omnibond.com,
	linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	corbet@lwn.net, cluster-devel@redhat.com, bo li liu <bo.li.liu@oracle.com>,
	v9fs-developer@lists.sourceforge.net,
	ross zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, viro@zeniv.linux.org.uk,
	axboe@kernel.dk, linux-nfs@vger.kernel.org, tytso@mit.edu,
	clm@fb.com, mawilcox@microsoft.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170509154930.29524-24-jlayton@redhat.com>
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

----- Original Message -----
| In some places, it's trying to reset the mapping error after calling
| filemap_fdatawait. That's no longer required. Also, turn several
| filemap_fdatawrite+filemap_fdatawait calls into filemap_write_and_wait.
| That will at least return writeback errors that occur during the write
| phase.
| 
| Signed-off-by: Jeff Layton <jlayton@redhat.com>
| ---

Hi Jeff,

This version looks better. ACK.

Regards,

Bob Peterson
Red Hat File Systems
