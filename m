From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4 18/19] btrfs: only dirty the inode in
 btrfs_update_time if something was changed
Date: Mon, 8 Jan 2018 18:59:20 +0100
Message-ID: <20180108175920.GF13726@twin.jikos.cz>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-19-jlayton@kernel.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org,
        bfields@fieldses.org, neilb@suse.de, jack@suse.de,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com, linux-integrity@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        jaltman@auristor.com
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171222120556.7435-19-jlayton@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 22, 2017 at 07:05:55AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> At this point, we know that "now" and the file times may differ, and we
> suspect that the i_version has been flagged to be bumped. Attempt to
> bump the i_version, and only mark the inode dirty if that actually
> occurred or if one of the times was updated.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Acked-by: David Sterba <dsterba@suse.com>
