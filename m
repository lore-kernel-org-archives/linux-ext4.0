From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfstests: fsstress should kill children tasks before
 exit
Date: Mon, 24 Oct 2011 05:06:45 -0400
Message-ID: <20111024090645.GA31887@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
 <1319020189-13584-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60465
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab1JXJGs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Oct 2011 05:06:48 -0400
Content-Disposition: inline
In-Reply-To: <1319020189-13584-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +int 		should_stop = 0;

this should use sig_atomic_t, or at least volatile.
>  
>  void	add_to_flist(int, int, int);
>  void	append_pathname(pathname_t *, char *);
> @@ -253,6 +256,10 @@ void	usage(void);
>  void	write_freq(void);
>  void	zero_freq(void);
>  
> +void sg_handler(int signum) {
> +	should_stop = 1;
> +}

please use normal K&R / Linux style brace placement.

