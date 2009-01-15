From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] ext2/3/4: change i_mutex usage on lseek
Date: Thu, 15 Jan 2009 13:01:54 +0000
Message-ID: <20090115130154.GA32368@shareable.org>
References: <6.0.0.20.2.20090106134318.06709010@172.19.0.2> <1231993950.9468.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1231993950.9468.8.camel@norville.austin.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:
> Is there any reason you couldn't have just changed generic_file_llseek()
> to do this rather than making identical changes to the individual file
> systems.  I would think this optimization would be safe for any file
> system.

Is it safe on 32-bit systems where 64-bit updates are not atomic?

You may say that doing multiple parallel lseek() calls is undefined
behaviour, so it's ok to end up with file position that none of the
individual lseek() calls asked for.

But if it's undefined behaviour, no programs should be doing parallel
lseek() calls on the same open file, so why optimise it at all?

-- Jamie
