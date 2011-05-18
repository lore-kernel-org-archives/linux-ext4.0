From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing
 error values back
Date: Wed, 18 May 2011 14:07:36 -0400
Message-ID: <20110518180736.GA10163@infradead.org>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <1305731882-8334-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>, tytso@mit.edu,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305731882-8334-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 18, 2011 at 05:18:00PM +0200, Jan Kara wrote:
> Create __block_page_mkwrite() helper which does all what block_page_mkwrite()
> does except that it passes back errors from __block_write_begin /
> block_commit_write calls.

Looks good to me.  Long term I wonder wether we should force
->page_mkwrite to always return the page locked and just use normal
errnos all the way up to do_wp_page, but that can be left for a later
iteration as it would be quite invasive.

Reviewed-by: Christoph Hellwig <hch@lst.de>
