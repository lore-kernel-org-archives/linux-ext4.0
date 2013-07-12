From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x4b9/0x6d0()
Date: Fri, 12 Jul 2013 15:42:29 -0400
Message-ID: <20130712194229.GC342@thunk.org>
References: <20130712193528.GA15261@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130712193528.GA15261@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 12, 2013 at 03:35:28PM -0400, Dave Jones wrote:
> Just hit a bunch of these..
> 
> WARNING: CPU: 0 PID: 995613 at fs/ext4/inode.c:230 ext4_evict_inode+0x4b9/0x6d0()

This is fixed up by the following commit which is queued up to be sent
to Linus, hopefully before he ships -rc1.  I'm just waiting for the
regression tests to complete before I sent a pull request.

Thanks for testing and reporting this warning!

	   	    	     	      	   - Ted

commit 822dbba33458cd6ad0e715f3f4a57ebc99d54d1b
Author: Jan Kara <jack@suse.cz>
Date:   Wed Jul 10 21:31:04 2013 -0400

    ext4: fix warning in ext4_evict_inode()
    
    The following race can lead to ext4_evict_inode() seeing i_ioend_count
    > 0 and thus triggering a sanity check warning:
    
            CPU1                                    CPU2
    ext4_end_bio()                          ext4_evict_inode()
      ext4_finish_bio()
        end_page_writeback();
                                              truncate_inode_pages()
                                                evict page
                                            WARN_ON(i_ioend_count > 0);
      ext4_put_io_end_defer()
        ext4_release_io_end()
          dec i_ioend_count
    
    This is possible use-after-free bug since we decrement i_ioend_count in
    possibly released inode.
    
    Since i_ioend_count is used only for sanity checks one possible solution
    would be to just remove it but for now I'd like to keep those sanity
    checks to help debugging the new ext4 writeback code.
    
    This patch changes ext4_end_bio() to call ext4_put_io_end_defer() before
    ext4_finish_bio() in the shortcut case when unwritten extent conversion
    isn't needed.  In that case we don't need the io_end so we are safe to
    drop it early.
    
    Reported-by: Guenter Roeck <linux@roeck-us.net>
    Tested-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
