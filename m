From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Add MAINTAINERS entry
Date: Thu, 26 May 2011 17:01:54 +0200
Message-ID: <20110526150154.GE5123@quack.suse.cz>
References: <20110523223207.GL4716@quack.suse.cz>
 <1306418034-31252-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1EZPB4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 11:01:56 -0400
Content-Disposition: inline
In-Reply-To: <1306418034-31252-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-05-11 09:53:54, Ted Tso wrote:
> Create a separate MAINTAINERS entry for jbd2
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  MAINTAINERS |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 649600c..0682c0e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3552,9 +3552,16 @@ M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Jan Kara <jack@suse.cz>
>  L:	linux-ext4@vger.kernel.org
>  S:	Maintained
> -F:	fs/jbd*/
> -F:	include/linux/ext*jbd*.h
> -F:	include/linux/jbd*.h
> +F:	fs/jbd/
> +F:	include/linux/ext3_jbd.h
> +F:	include/linux/jbd.h
> +
> +JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
> +M:	"Theodore Ts'o" <tytso@mit.edu>
> +L:	linux-ext4@vger.kernel.org
> +S:	Maintained
> +F:	fs/jbd2/
> +F:	include/linux/jbd2.h
>  
>  JSM Neo PCI based serial card
>  M:	Breno Leitao <leitao@linux.vnet.ibm.com>
> -- 
> 1.7.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
