From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: delayed inode update for the consistency of file
 size after a crash
Date: Mon, 18 Dec 2017 04:32:02 -0800
Message-ID: <20171218123202.GA25645@infradead.org>
References: <20171216043326.GA12365@son-VirtualBox>
 <20171216233239.oy4mcyjuq6hjugnx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
        Seongbae Son <seongbae.son@gmail.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171216233239.oy4mcyjuq6hjugnx@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> that update of the timestamp and i_size needs to be moved to an I/O
> completion handler.  We do this already to convert unwritten requests
> to be written in fs/ext4/page_io.c.  See ext4_put_io_end_defer() in
> fs/ext4/page_io.c; if we need to convert unwritten extents the
> EXT4_IO_END_UNWRITTEN flag is set, and ext4_add_complete_io() tacks
> the io_end queue onto a workqueue.  This infrastructure could be made
> more general so that it can do other work after the I/O has been
> completed, including the i_size update.

That's what we do for the i_size update in XFS.
