From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/5] ext4: Code cleanup
Date: Mon, 15 Oct 2007 12:10:39 -0600
Message-ID: <20071015181039.GU8122@schatzie.adilger.int>
References: <1192445738-17591-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1192445738-17591-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:54539 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbXJOSKl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 14:10:41 -0400
Content-Disposition: inline
In-Reply-To: <1192445738-17591-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 15, 2007  16:25 +0530, Aneesh Kumar K.V wrote:
> -		if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
> -			err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> -			if (err) goto fail;
> -			EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS);
> -			BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "call ext4_journal_dirty_metadata");
> -			err = ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
> -		}
> +		err = ext4_update_incompat_feature(handle, sb,
> +						EXT4_FEATURE_INCOMPAT_EXTENTS);
> +		if (err)
> +			goto fail;
> +
> +		BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "call ext4_update_feautre");

You may as well put the BUFFER_TRACE() all into
ext4_update_incompat_feature().

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
