From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems building xfsprogs
Date: Thu, 21 Jul 2011 05:06:19 -0400
Message-ID: <20110721090619.GA26263@infradead.org>
References: <20110720175918.GB17971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        xfs-oss <xfs@oss.sgi.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20110720175918.GB17971@thunk.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 20, 2011 at 01:59:18PM -0400, Ted Ts'o wrote:
> a) "make configure" doesn't work until I patch the top-level Makefile:
> 
> diff --git a/Makefile b/Makefile
> index c40fb2c..37973f5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -82,7 +82,7 @@ configure:
>  	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
>  	cp include/install-sh .
>  	aclocal -I m4
> -	autoconf
> +	autoconf -I m4
>  
>  include/builddefs: configure
>  	./configure $$LOCAL_CONFIGURE_OPTIONS

I works fine for me on various releases of Debian, Fedsora, RHEL and
SLES.  But all he machines I've quickly checked seem to have an autoconf
that can handle -I, so could you please send this pach with a proper
signoff and description?

> b) By default xfsprogs builds with DEBUG, and this causes building
> libxfs/xfs_ialloc.c to blow up since there a reference of
> xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> two figure this out....

The defaul actually is DEBUG=-DNDEBUG.  No sure how you go he debug
build. but we surely should fix it.  I'll add the stub as soon as I get
some time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
