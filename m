From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] Add batched discard support for ext3
Date: Wed, 4 Aug 2010 16:03:45 +0200
Message-ID: <20100804140345.GA4139@quack.suse.cz>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
 <1280929475-12823-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab0HDOEQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 10:04:16 -0400
Content-Disposition: inline
In-Reply-To: <1280929475-12823-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  The patch looks good. Just one small thing:

On Wed 04-08-10 15:44:34, Lukas Czerner wrote:
> +	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
> +	if (!gdp)
> +		goto err_out;
> +
> +	BUFFER_TRACE(gd_bh, "get_write_access");
                     ^^^^^ gdp_bh

  So you can add: Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
