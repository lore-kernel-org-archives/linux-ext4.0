From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 17/19] xfs: avoid setting XFS_ILOG_CORE if i_version
 doesn't need incrementing
Date: Wed, 10 Jan 2018 09:48:22 +1100
Message-ID: <20180109224822.GL16421@dastard>
References: <20180109141059.25929-1-jlayton@kernel.org>
 <20180109141059.25929-18-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org,
        bfields@fieldses.org, neilb@suse.de, jack@suse.de,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        jaltman@auristor.com, krzk@kernel.org
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109141059.25929-18-jlayton@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 09, 2018 at 09:10:57AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> If XFS_ILOG_CORE is already set then go ahead and increment it.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
