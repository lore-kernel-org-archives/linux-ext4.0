From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] quota: Implement project id support for generic
	quota
Date: Thu, 11 Mar 2010 07:03:34 -0500
Message-ID: <20100311120334.GB4706@infradead.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab0CKMDf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 07:03:35 -0500
Content-Disposition: inline
In-Reply-To: <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 09:34:34PM +0300, Dmitry Monakhov wrote:
>  		case GRPQUOTA:
>  			return in_group_p(dquot->dq_id);
> +		case PRJQUOTA:
> +			/* XXX: Currently there is no way to understand
> +			   which project_id this task belonges to, So print
> +			   a warn message unconditionally. -dmon */
> +			return 1;

Note that this is different from the XFS behaviour, which neve warns
for project quota.  In fact project quota in XFS traditionally doesn't
even return EDQUOT but ENOSPC instead, as it's not a traditional quota
mechanism but filesystem containerization.

Otherwise the patch looks good except for the ifdef mess already comment
on in the previous patch.
