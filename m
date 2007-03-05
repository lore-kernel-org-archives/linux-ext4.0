From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 09:37:03 -0500
Message-ID: <20070305143703.GF26781@thunk.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 04, 2007 at 11:22:06PM +0000, Anton Altaparmakov wrote:
> And I specifically did NOT update the initialized size in the inode  
> thus it will remain at its old value thus all new allocated blocks  
> will be considered as present but not initialized thus a read will  
> always return zero whilst a write will do the right thing and pad  
> with zeroes as necessary (if the write is smaller than the block  
> size, etc).

Anton,

	You're describing a method of doing in-advance preallocation
where the filesystem format explicitly has support for this kind of
feature in a way that doesn't require pre-zeroing the data blocks in
question.

	The question which this subthread was concerned about was
whether the kernel should get involved in initializing datablocks in
the case where the filesystem format does not have this support, or
whether this functionality should continue to be done in userspace.
Given that glibc already has to support this for older kernels, I
would argue that there's no point putting in generic support for
filesystem that can't support a more advanced way of doing things.

	Regards,

						- Ted
