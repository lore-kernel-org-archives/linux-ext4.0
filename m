From: Patrick Palka <patrick@parcs.ath.cx>
Subject: Re: [PATCH v2] ext4: check inline directory before converting
Date: Tue, 5 Aug 2014 12:20:12 +0000 (UTC)
Message-ID: <loom.20140805T141533-363@post.gmane.org>
References: <20140725222356.GK8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38619 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbaHEMZL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Aug 2014 08:25:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1XEdnb-0001Eg-0S
	for linux-ext4@vger.kernel.org; Tue, 05 Aug 2014 14:25:03 +0200
Received: from ool-4353af5c.dyn.optonline.net ([67.83.175.92])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 05 Aug 2014 14:25:03 +0200
Received: from patrick by ool-4353af5c.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 05 Aug 2014 14:25:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Darrick J. Wong <darrick.wong <at> oracle.com> writes:

> +int ext4_check_all_de(struct inode *dir, struct buffer_head *bh, void 
*buf,
> +		      int buf_size)
> +{
> +	struct ext4_dir_entry_2 *de;
> +	int nlen, rlen;

Is nlen actually used in this function?

> +	unsigned int offset = 0;
> +	char *top;
> +
> +	de = (struct ext4_dir_entry_2 *)buf;
> +	top = buf + buf_size;
> +	while ((char *) de < top) {
> +		if (ext4_check_dir_entry(dir, NULL, de, bh,
> +					 buf, buf_size, offset))
> +			return -EIO;
> +		nlen = EXT4_DIR_REC_LEN(de->name_len);

It is set here, but its value is never used.

