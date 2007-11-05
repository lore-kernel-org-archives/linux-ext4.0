From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Mon, 5 Nov 2007 17:06:09 -0500
Message-ID: <20071105220609.GB7480@thunk.org>
References: <472F8792.6030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXKEWG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 17:06:57 -0500
Content-Disposition: inline
In-Reply-To: <472F8792.6030808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 05, 2007 at 03:13:54PM -0600, Eric Sandeen wrote:
> Another one that's been in RH/Fedora specfiles a while.
> Remove timestamps from .po files to avoid multilib conflicts.
> It ain't pretty but it works.

The patch is missing remove-potcdate.sed; can you include it and
resend it please?  Thanks!!

					- Ted

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Addresses-Red-Hat-Bugzilla: #245653
> 
> Index: e2fsprogs-git/po/Makefile.in.in
> ===================================================================
> --- e2fsprogs-git.orig/po/Makefile.in.in
> +++ e2fsprogs-git/po/Makefile.in.in
> @@ -118,10 +118,12 @@ $(DOMAIN).pot-update: $(POTFILES) $(srcd
>  	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(DOMAIN).po; \
>  	    else \
>  	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(srcdir)/$(DOMAIN).pot && \
> -	      mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
> +	      sed -f remove-potcdate.sed < $(DOMAIN).po > $(srcdir)/$(DOMAIN).pot && \
> +	      rm -f $(DOMAIN).po; \
>  	    fi; \
>  	  else \
> -	    mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
> +	    sed -f remove-potcdate.sed < $(DOMAIN).po > $(srcdir)/$(DOMAIN).pot && \
> +	    rm -f $(DOMAIN).po; \
>  	  fi; \
>  	}
>  
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
