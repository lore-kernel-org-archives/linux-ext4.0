From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/32] ext4: add ext4_is_quota_file()
Date: Thu, 22 Jun 2017 11:39:33 -0400
Message-ID: <20170622153933.gjc4ni47spchlix6@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-2-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-2-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:32PM -0700, Tahsin Erdogan wrote:
> IS_NOQUOTA() indicates whether quota is disabled for an inode. Ext4
> also uses it to check whether an inode is for a quota file. The
> distinction currently doesn't matter because quota is disabled only
> for the quota files. When we start disabling quota for other inodes
> in the future, we will want to make the distinction clear.
> 
> Replace IS_NOQUOTA() call with ext4_is_quota_file() at places where
> we are checking for quota files.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Added to the ext4 patch queue, thanks.

				- Ted
