From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -V3 1/9] ext4: sparse fixes
Date: Thu, 6 Nov 2008 17:09:54 -0500
Message-ID: <20081106220954.GM18939@mit.edu>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42685 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbYKFWJ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 17:09:59 -0500
Content-Disposition: inline
In-Reply-To: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 12:19:26AM +0530, Aneesh Kumar K.V wrote:
>  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_compat) & mask)
>  #define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
> -	(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
> +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) & mask)
>  #define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
> -	(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
> +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) & mask)

This is going to force a byte-swap instruction on every single
big-endian system out there, which could potentially be costly, or at
least undeed given that all of the times that these functions are
called, the result gets used only as a booelan.

Can we shut up sparse by using a explicit cast to an unsigned int?

       	       	      	       	 	  - Ted
