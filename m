From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Tue, 24 Mar 2009 15:56:03 +0100
Message-ID: <1237906563.24918.184.camel@twins>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz>
	 <200903250130.02485.nickpiggin@yahoo.com.au>
	 <20090324144709.GF23439@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Martin J. Bligh" <mbligh@mbligh.org>,  linux-ext4@vger.kernel.org, Ying Han <yinghan@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,  linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, guichaz@gmail.com, Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>, Rohit Seth <rohitseth@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090324144709.GF23439@duck.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2009-03-24 at 15:47 +0100, Jan Kara wrote:
> 
> Or we could implement ext3_mkwrite() to allocate buffers already when we
> make page writeable. But it costs some performace (we have to write page
> full of zeros when allocating those buffers, where previously we didn't
> have to do anything) and it's not trivial to make it work if pagesize >
> blocksize (we should not allocate buffers outside of i_size so if i_size
> = 1024, we create just one block in ext3_mkwrite() but then we need to
> allocate more when we extend the file).

I think this is the best option, failing with SIGBUS when we fail to
allocate blocks seems consistent with other filesystems as well.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
