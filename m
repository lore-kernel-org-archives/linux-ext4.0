From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] Implement project id support for generic quota
Date: Fri, 22 Jun 2012 02:01:52 +0200
Message-ID: <20120622000152.GE11645@quack.suse.cz>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1340269733-25922-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 21-06-12 13:08:50, Dmitry Monakhov wrote:
> Since all preparation code are already in quota-tree,
> So this patch is really small.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
...
> @@ -48,6 +54,7 @@
>  #define INITQFNAMES { \
>  	"user",    /* USRQUOTA */ \
>  	"group",   /* GRPQUOTA */ \
> +	"project",  /* RPJQUOTA */	\
  Typo above - should be PRJQUOTA.

>  	"undefined", \
>  };

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
