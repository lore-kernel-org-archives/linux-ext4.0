From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Wed, 4 Feb 2009 09:09:11 -0500
Message-ID: <20090204140911.GB14762@mit.edu>
References: <49829A1D.5090002@rs.jp.nec.com> <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com> <49894CD4.4060000@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49894CD4.4060000@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 04, 2009 at 05:07:48PM +0900, Akira Fujita wrote:
>> Do we want the ioctl name to be specific to defrag?  I thought Ted's
>> goal was to make it more generic?  I can also envision this same ioctl
>> being implemented by other file systems so EXT4 seems an inappropriate
>> prefix.

When I said generic I meant in terms of decomposing the functionality
into multiple ioctls which each could be useful for multiple purposes.
Not necessarily in terms of being used by other filesystem, because
they will almost certainly have their own requirements.

So for example, primitives like "allocate blocks for this inode from
this region of the disk", or "don't allocate blocks for any inode in
this region of disk", can be used for multiple things (such as on-line
shrink), and not just defragmentation.

I don't want to move this to the VFS layer, since it will involve huge
amounts of time while people argue over generic issues regarding the
interface.  Look at how long it took to settle on the FIEMAP
interface; that's not an experience I care to repeat.

>>> struct move_extent {
>>>        int org_fd;             /* original file descriptor */
>>>        int dest_fd;            /* destination file descriptor */
>>>        ext4_lblk_t start;      /* logical offset of org_fd and dest_fd */
>>>        ext4_lblk_t len;        /* exchange block length */
>>> };
>>
>> I would also like to see .dest_fd changed to .donor_fd.

Agreed --- dest_fd is very confusing, because while the data is moving
to the blocks contributed by the donor_fd, the actual inode which
remains pointed to by all of the directory entries is the org_fd.  But
people who think of the operation as the blocks moving to the
"destination fd", will get completely confused.  Donor makes more
sense, since it has the sense of "organ transplant", which makes a lot
more sense.

						- Ted
