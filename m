From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: remove another test in ext4_alloc_file_blocks()
Date: Sat, 3 Dec 2016 16:47:58 -0500
Message-ID: <20161203214758.4jo2dhgjm5ujqzhw@thunk.org>
References: <20161012060002.GA12778@mwanda>
 <20161021095435.GC8271@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Fabian Frederick <fabf@skynet.be>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021095435.GC8271@quack2.suse.cz>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2016 at 11:54:35AM +0200, Jan Kara wrote:
> On Wed 12-10-16 09:00:02, Dan Carpenter wrote:
> > Before commit c3fe493ccdb1 ('ext4: remove unneeded test in
> > ext4_alloc_file_blocks()') then it was possible for "depth" to be -1
> > but now, it's not possible that it is negative.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
