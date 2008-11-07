From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH -V3 1/9] ext4: sparse fixes
Date: Fri, 7 Nov 2008 10:07:56 -0500
Message-ID: <20081107150756.GA18444@infradead.org>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081106220954.GM18939@mit.edu> <20081107142022.GK25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKGPIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 10:08:20 -0500
Content-Disposition: inline
In-Reply-To: <20081107142022.GK25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 07:50:22PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Nov 06, 2008 at 05:09:54PM -0500, Theodore Tso wrote:
> > On Fri, Nov 07, 2008 at 12:19:26AM +0530, Aneesh Kumar K.V wrote:
> > >  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> > > -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> > > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_compat) & mask)
> > >  #define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
> > > -	(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
> > > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) & mask)
> > >  #define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
> > > -	(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
> > > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) & mask)
> > 
> > This is going to force a byte-swap instruction on every single
> > big-endian system out there, which could potentially be costly, or at
> > least undeed given that all of the times that these functions are
> > called, the result gets used only as a booelan.
> > 
> > Can we shut up sparse by using a explicit cast to an unsigned int?
> 
> I did it that way first But found the error path needing conversion.
> But i guess it is ok since it happen in the error path printk.


>  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> +	(__force __u32)(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))

Umm, no.  You're not returning a __u32 here, but a flag.

	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)

should do the right thing.

