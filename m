From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption in data=journal mode
Date: Wed, 1 Feb 2017 14:06:49 -0500
Message-ID: <20170201190649.yi7yiavisbi2zmpe@thunk.org>
References: <20170110123753.8405-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110123753.8405-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 10, 2017 at 01:37:53PM +0100, Jan Kara wrote:
> ext4_journalled_write_end() did not propely handle all the cases when
> generic_perform_write() did not copy all the data into the target page
> and could mark buffers with uninitialized contents as uptodate and dirty
> leading to possible data corruption (which would be quickly fixed by
> generic_perform_write() retrying the write but still). Fix the problem
> by carefully handling the case when the page that is written to is not
> uptodate.
> 
> CC: stable@vger.kernel.org
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
