From: Ted Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Mon, 4 Jun 2012 18:26:46 -0400
Message-ID: <20120604222646.GA6525@thunk.org>
References: <471046920.20120604234941@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sander Eikelenboom <linux@eikelenboom.it>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <471046920.20120604234941@eikelenboom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 04, 2012 at 11:49:41PM +0200, Sander Eikelenboom wrote:
> Hello Ted,
> 
> I have enabled some debug options, this is from around when the error occurs (kernel: [  950.610126] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd)

This error is usually caused by a filesystem corruption; specifically,
either a corrupted block allocation bitmap or a corrupted block group
descriptor.  This error means that number of bits set in the block
allocation bitmap (32254) doesn't match the number that is reflected
in the summary block group descriptor statistics (32258).

I should probably change this error message so it's clearer what this
means to civilians.

If you run e2fsck on the file system, it will fix the file system
corruption.  If you can reliably reproduce the problem after e2fsck is
run, that would be useful to know.

Regards,

						- Ted
