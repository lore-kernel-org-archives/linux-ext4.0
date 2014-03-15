From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] readahead.2: don't claim the call blocks until all data
 has been read
Date: Sat, 15 Mar 2014 02:24:55 -0700
Message-ID: <20140315092455.GA6018@infradead.org>
References: <1394812471-9693-1-git-send-email-psusi@ubuntu.com>
 <532417CA.1040300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-man@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	"Gregory P. Smith" <gps@google.com>,
	Zhu Yanhai <zhu.yanhai@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <532417CA.1040300@gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 15, 2014 at 10:05:14AM +0100, Michael Kerrisk (man-pages) wrote:
>        However, it may block while  it  reads
>        the  filesystem metadata needed to locate the requested blocks.
>        This occurs frequently with ext[234] on large files using indi???
>        rect  blocks instead of extents, giving the appearence that the
>        call blocks until the requested data has been read.
> 
> Okay?

The part above is something that should be in the BUGS section.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
