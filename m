From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3 2/4] Return 32/64-bit dir name hash according to
 usage type
Date: Fri, 19 Aug 2011 18:29:51 -0400
Message-ID: <20110819222951.GC3578@thunk.org>
References: <20110816115404.1810393.47239.stgit@localhost.localdomain>
 <20110816115414.1810393.92169.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	bfields@fieldses.org, bernd.schubert@fastmail.fm,
	hch@infradead.org, adilger@whamcloud.com, yong.fan@whamcloud.com,
	linux-fsdevel@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110816115414.1810393.92169.stgit@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 16, 2011 at 01:54:14PM +0200, Bernd Schubert wrote:
> +static inline int is_32bit_api(void)
> +{
> +#ifdef HAVE_IS_COMPAT_TASK
> +	return is_compat_task();
> +#else
> +	return (BITS_PER_LONG == 32);
> +#endif

I assume is_compat_task() is coming from another patch?  What is the
status of that change?

In the case where is_compat_task() is not defined, we can't just test
based on BITS_PER_LONG == 32, since even on an x86_64 machine, it's
possible we're running a 32-bit binary in compat mode....

	       	       	 	       	  - Ted
