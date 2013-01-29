From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Mon, 28 Jan 2013 22:03:53 -0500
Message-ID: <20130129030353.GK7003@thunk.org>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 23, 2013 at 08:03:53PM +0800, Zheng Liu wrote:
> +	ext4_fsblk_t es_pblk : 62;	/* first physical block */
> +	ext4_fsblk_t es_status : 2;	/* record the status of extent */

I'll accept this for now but note that ext4_fsblk_t is typedefed to be
an unsigned long long, and C99 only guarantees that bitfields can be
made from Bool, signed int, and unsigned int.  Gcc accepts unsigned
long long based bit fields as an extension, but it's not portable
code.  This is kernel code, though, and we have plenty more gcc
specific code....

						- Ted


