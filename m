From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: move more common code into journal_init_common()
Date: Thu, 15 Sep 2016 12:03:09 -0400
Message-ID: <20160915160309.okkvwpxz4im5abti@thunk.org>
References: <cover.1473240936.git.geliangtang@gmail.com>
 <50f2f9e8f6e503a3bd9a54b4dcb58531e18dbf52.1473240936.git.geliangtang@gmail.com>
 <20160907131624.GU28922@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geliang Tang <geliangtang@gmail.com>, Jan Kara <jack@suse.com>,
        Eric Ren <zren@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160907131624.GU28922@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 07, 2016 at 03:16:24PM +0200, Jan Kara wrote:
> On Wed 07-09-16 20:41:13, Geliang Tang wrote:
> > There are some repetitive code in jbd2_journal_init_dev() and
> > jbd2_journal_init_inode(). So this patch moves the common code into
> > journal_init_common() helper to simplify the code. And fix the coding
> > style warnings reported by checkpatch.pl by the way.
> > 
> > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
