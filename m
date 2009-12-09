From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] [RFC] vfs: add generic reserved space management
	interface
Date: Wed, 9 Dec 2009 05:45:42 -0500
Message-ID: <20091209104542.GA10500@infradead.org>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 09, 2009 at 05:11:24AM +0300, Dmitry Monakhov wrote:
> Add new field "i_rsv_blocks" to generic inode. This value is
> managed similar to i_blocks, i_bytes fileds (protected by i_lock).
> This generic interface will be used by generic quota code similar
> to i_blocks.

Please don't bloat the VFS inode for this information.

