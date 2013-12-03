From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: fix iversion handling
Date: Tue, 3 Dec 2013 01:39:44 -0800
Message-ID: <20131203093944.GA4906@infradead.org>
References: <20131119151707.GA13412@infradead.org>
 <20131202173636.GA17724@infradead.org>
 <8E57B1B6-E650-4A1A-AF78-0A9C9593A3E3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8E57B1B6-E650-4A1A-AF78-0A9C9593A3E3@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 02, 2013 at 03:05:07PM -0700, Andreas Dilger wrote:
> >> 	 */
> >> -	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
> >> -		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
> >> +	if (newsize != oldsize) {
> >> +		inode_inc_iversion(inode);
> 
> Should this be conditional on IS_I_VERSION(inode)?

btrfs sets MS_I_VERSION unconditionally.

