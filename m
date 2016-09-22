From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypt: in-place decrypt vs. out-of-place encrypt?
Date: Thu, 22 Sep 2016 09:14:09 -0400
Message-ID: <20160922131409.k3da62qznmgjucpx@thunk.org>
References: <f3f489f1-3ec0-e8c8-d5ae-ea6b9e5d5571@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <f3f489f1-3ec0-e8c8-d5ae-ea6b9e5d5571@nod.at>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 10:49:41AM +0200, Richard Weinberger wrote:
> 
> While reading the fscrypt code I noticed that some functions use the bounce pages
> and some not.
> fscrypt_decrypt_page() and fscrypt_decrypt_bio_pages() work in-place while
> fscrypt_encrypt_page() and fscrypt_zeroout_range() use a bounce page.
> 
> So, both ext4 and f2fs encrypt data using an extra buffer but decrypt mostly
> in-place without the need of an extra buffer.
> Why that? I'd assume when decryption can be done in-place also encryption is possible
> that way.

The problem is that the page may be mapped into some process's (or
multiple processes') address space.  The only way we can encrypt in
place is if we make sure that it is not mapped into any processes'
page tables, and prohibit it from being mmapped, *and* prevent any
simultaneous reads from accessing the page for which we are in the
process of destroying its original contents because we are doing an
in-plance encrypt.

So it could be done, but you would have to remove the page from the
page cache first (meaning making sure it's not in any page tables) so
it can't be found by subsequent reads and mmaps, and then sure you
have a lock out which prevents anyone else from trying to read or mmap
the page(s) in question, since the version on the storage device is
out-of-date, because it hasn't been written yet.

So basically, it's a mess, and if you do need the page again after
it's been written, the fact that you have to read it back in from the
storage device would also be a performance hit in some cases.

> I'm working on fscrypt for UBIFS and would like to avoid an extra
> buffer since memory is low on embedded systems.

The amount of memory needed for the bounce pages is relative to the
speed of your storage device.  It should be possible throttle how much
memory gets used based on how many I/O's you allow to be in flight at
any one time, and hence, how much memory is needed for bounce buffers.

In the long run, I suspect that the real answer for embedded devices
will be hardware support in the form of in-line encryption engines,
since embedded devices tend to have pathetically slow CPU support for
encryption anyway.  It also solves the problem where you have an
extremely unbalanced system (i.e., expensive PCIe attached flash that
can do thousands of IOPS per second, and a tiny wee bit of memory :-)

       		    	     	     	 - Ted

------------------------------------------------------------------------------
