From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/32] ext4: modify ext4_xattr_ino_array to hold struct
 inode *
Date: Thu, 22 Jun 2017 10:28:04 -0400
Message-ID: <20170622142804.trfy3ce6wibh5amx@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-21-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-21-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:31PM -0700, Tahsin Erdogan wrote:
> Tracking struct inode * rather than the inode number eliminates the
> repeated ext4_xattr_inode_iget() call later. The second call cannot
> fail in practice but still requires explanation when it wants to ignore
> the return value. Avoid the trouble and make things simple.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Added to the ext4 patch queue, thanks.

      	     	  	       - Ted
