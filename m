From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Tue, 29 Jan 2013 13:34:15 +0800
Message-ID: <20130129053415.GA27002@gmail.com>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
 <20130129030353.GK7003@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130129030353.GK7003@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 28, 2013 at 10:03:53PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 23, 2013 at 08:03:53PM +0800, Zheng Liu wrote:
> > +	ext4_fsblk_t es_pblk : 62;	/* first physical block */
> > +	ext4_fsblk_t es_status : 2;	/* record the status of extent */
> 
> I'll accept this for now but note that ext4_fsblk_t is typedefed to be
> an unsigned long long, and C99 only guarantees that bitfields can be
> made from Bool, signed int, and unsigned int.  Gcc accepts unsigned
> long long based bit fields as an extension, but it's not portable
> code.  This is kernel code, though, and we have plenty more gcc
> specific code....

Thanks for pointing out.  When I tried to implement this code, there are
two choices.  One is like this that bit field is used.  IMHO it is clear
enough, although it is not portable.

Another choice is like this:

        struct extent_status {
                ...
                ext4_fsblk_t es_pblk;   /* first physical block */
        };

        #define EXTENT_STATUS_WRITTEN   (1ULL << 60)
        #define EXTENT_STATUS_UNWRITTEN (1ULL << 61)
        #define EXTENT_STATUS_DELAYED   (1ULL << 62)

When we want to set extent status, we will need to do like the following:

        es->es_pblk |= EXTENT_STATUS_WRITTEN;

This can make us avoid non-protable code.  I am happy to refine this
patch if you think the latter one is better.

Thanks,
                                                - Zheng
