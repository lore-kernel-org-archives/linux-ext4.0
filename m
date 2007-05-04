From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] ext4: Extent overlap bugfix
Date: Thu, 3 May 2007 21:30:02 -0700
Message-ID: <20070503213002.eff696db.akpm@linux-foundation.org>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426181101.GC7209@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767562AbXEDEaO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 00:30:14 -0400
In-Reply-To: <20070426181101.GC7209@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 26 Apr 2007 23:41:01 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> +unsigned int ext4_ext_check_overlap(struct inode *inode,
> +					struct ext4_extent *newext,
> +					struct ext4_ext_path *path)
> +{
> +	unsigned long b1, b2;
> +	unsigned int depth, len1;
> +
> +	b1 = le32_to_cpu(newext->ee_block);
> +	len1 = le16_to_cpu(newext->ee_len);
> +	depth = ext_depth(inode);
> +	if (!path[depth].p_ext)
> +		goto out;
> +	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
> +
> +	/* get the next allocated block if the extent in the path
> +	 * is before the requested block(s) */
> +	if (b2 < b1) {
> +		b2 = ext4_ext_next_allocated_block(path);
> +		if (b2 == EXT_MAX_BLOCK)
> +			goto out;
> +	}
> +
> +	if (b1 + len1 > b2) {

Are we sure that b1+len cannot wrap through zero here?

> +		newext->ee_len = cpu_to_le16(b2 - b1);
> +		return 1;
> +	}
