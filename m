From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/32] ext4: add missing le32_to_cpu(e_value_inum)
 conversions
Date: Wed, 21 Jun 2017 22:00:36 -0400
Message-ID: <20170622020036.oecpct2smaogmjz3@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-12-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-12-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:22PM -0700, Tahsin Erdogan wrote:
> Two places in code missed converting xattr inode number using
> le32_to_cpu().
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

	      	     	  - Ted
