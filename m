From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 1/3] ext4: Add EXT4_IOC_DEFRAG ioctl and basic
	defrag functions
Date: Wed, 4 Feb 2009 09:59:51 -0500
Message-ID: <20090204145951.GD14762@mit.edu>
References: <49829A37.8050701@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49829A37.8050701@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 30, 2009 at 03:12:07PM +0900, Akira Fujita wrote:
> + *
> + * Note that the extents of target file(@o_filp) are always converted
> + * from "uninitialized" to "initialized" after swapping the blocks
> + * between the original file and the destination one(@d_filp).
> + * In the next version, this behavior will be fixed not to change extents'
> + * initializing status.

Note also that if the extent in the target file is "uninitialized",
it's not necessary to force the page into memory and then force it to
be written out again.  This is important if the file involved is a
large database file which still has large areas preallocated, but not
yet initialized.

						- Ted
