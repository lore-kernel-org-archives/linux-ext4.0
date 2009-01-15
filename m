From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext2/3/4: change i_mutex usage on lseek
Date: Thu, 15 Jan 2009 08:35:30 -0500
Message-ID: <20090115133530.GA30522@mit.edu>
References: <6.0.0.20.2.20090106134318.06709010@172.19.0.2> <1231993950.9468.8.camel@norville.austin.ibm.com> <20090115130154.GA32368@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090115130154.GA32368@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 15, 2009 at 01:01:54PM +0000, Jamie Lokier wrote:
> Dave Kleikamp wrote:
> > Is there any reason you couldn't have just changed generic_file_llseek()
> > to do this rather than making identical changes to the individual file
> > systems.  I would think this optimization would be safe for any file
> > system.
> 
> Is it safe on 32-bit systems where 64-bit updates are not atomic?

Protection of 64-bit updates of i_size where 32-bit systems do not
have atomic 64-bit updates is done via i_size_seqcount, which is done
automatically as long as the code in question uses i_size_write(), an
inline function defined in include/linux/fs.h.

> You may say that doing multiple parallel lseek() calls is undefined
> behaviour, so it's ok to end up with file position that none of the
> individual lseek() calls asked for.
> 
> But if it's undefined behaviour, no programs should be doing parallel
> lseek() calls on the same open file, so why optimise it at all?

i_mutex gets used for a lot more than protecting i_size updates for
lseek(), so removing the need for i_mutex could very well be helpful
for non-micro-benchmark tests.  As Hirashi-san mentioned in his patch,
this could avoid contention between lseek() and write() (possibly via
a different file descriptor, so it wouldn't be an undefined race
condition) and fsync().

I do agree this is an optimization that should be done in
generic_file_llseek(), though.

Regards,

						- Ted
