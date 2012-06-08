From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 5/4] exofs: Handle error from d_splice_alias()
Date: Fri, 8 Jun 2012 22:59:50 +0100
Message-ID: <20120608215950.GQ30000@ZenIV.linux.org.uk>
References: <1338322067-17566-1-git-send-email-jack@suse.cz>
 <4FC5F8CC.20400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FC5F8CC.20400@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 30, 2012 at 01:39:08PM +0300, Boaz Harrosh wrote:
> +	ret = d_splice_alias(inode, dentry);
> +	if (IS_ERR(ret)) {
> +		EXOFS_ERR("directory #%lu corrupted", dir->i_ino);
> +		iput(inode);

That's a bloody wrong interface.  If you add d_splice_alias() failure
exit like that, do iput() *there*.  Requiring every caller to deal with
failure exit cleanups like that is the recipe for recurring bugs.
Don't Do That.
