From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/32] ext4: move struct ext4_xattr_inode_array to xattr.h
Date: Thu, 22 Jun 2017 10:29:07 -0400
Message-ID: <20170622142907.ftqvodcavg7moyge@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-22-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-22-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:32PM -0700, Tahsin Erdogan wrote:
> Since this is a xattr specific data structure it is cleaner to keep it in
> xattr header file.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks.

					- Ted
