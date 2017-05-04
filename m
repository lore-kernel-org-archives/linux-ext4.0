From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/7] jbd2: Cleanup write flags handling from
 jbd2_write_superblock()
Date: Thu, 4 May 2017 11:00:00 -0400
Message-ID: <20170504150000.4msomavjh7eqj2og@thunk.org>
References: <20170502150351.29452-1-jack@suse.cz>
 <20170502150351.29452-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502150351.29452-3-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 02, 2017 at 05:03:46PM +0200, Jan Kara wrote:
> Currently jbd2_write_superblock() silently adds REQ_SYNC to flags with
> which journal superblock is written. Make this explicit by making flags
> passed down to jbd2_write_superblock() contain REQ_SYNC.
> 
> CC: "Theodore Ts'o" <tytso@mit.edu>
> CC: linux-ext4@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
