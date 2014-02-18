From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] jbd2: use after free in jbd2_journal_start_reserved()
Date: Mon, 17 Feb 2014 20:27:52 -0500
Message-ID: <20140218012752.GD26580@thunk.org>
References: <20140213111953.GC15549@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140213111953.GC15549@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 13, 2014 at 02:19:53PM +0300, Dan Carpenter wrote:
> If start_this_handle() fails then it leads to a use after free of
> "handle".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

						- Ted
