From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
Date: Wed, 07 Aug 2013 10:40:52 -0700
Message-ID: <520286A4.1020101@intel.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130807134058.GC12843@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 08/07/2013 06:40 AM, Jan Kara wrote:
>   One question before I look at the patches: Why don't you use fallocate()
> in your application? The functionality you require seems to be pretty
> similar to it - writing to an already allocated block is usually quick.

One problem I've seen is that it still costs you a fault per-page to get
the PTEs in to a state where you can write to the memory.  MADV_WILLNEED
will do readahead to get the page cache filled, but it still leaves the
pages unmapped.  Those faults get expensive when you're trying to do a
couple hundred million of them all at once.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
