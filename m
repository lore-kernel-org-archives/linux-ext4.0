Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16C47F2F6
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788351863; cv=none; b=tZSAPsmNuTFm4FS+YisFaMOM1Z8o6l1zSD2eQL1Dlujho8CbG/ppbZWY3x8ts9DNnkUW8AyumBnavjhL1ujMAjkMCZDOoVf9ZCBQ+WlpqCR3Vu7eRqhvOLt9PFpraQSvPHVnGdfvjb4KEzLlKdb81XWvHJZEGU7cOScsYSE0bhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788351863; c=relaxed/simple;
	bh=+D4ZnZz93GRWzPOKqT/L1qWle797X9rbuFtqH2+tal8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYjudmvDM6Z1WaVAO8F0jVtJV+7V5/6Yhb+/tIZ/F9IvHta9Bh8NM2jcbvNYMrhWP+ReBvszQNh14m9sn3MK8XBu3UzniAfTIw7HhD2j961bKSqdddPiBEfq3m4aKjwN9/6icWHLv80kgysHoYF6i0AiY4b3fSqtnzy30YdhFiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=qxYVZytw; arc=none smtp.client-ip=203.205.221.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="qxYVZytw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1788351851; bh=oeGrkJR2LSXUl4C5e/Md9Vtxpmk92D1xpVjUamNgopI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qxYVZytwXSsqjG/92w+vPp9aduaJe3t0/8+zvgCuVnPpOqPrgXI2rPXTPRA3GUs17
	 NpBz/R9FDegqrYWpe79W2Oz3Vv2YuwovnYIEvEyTP9vnfL/Z5KJOb68yspR5RgpaLB
	 s3SoDRls5AYZT+R0qX69m0yVyk64al0IyxBIYmMg=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 6081624C; Wed, 02 Sep 2026 20:24:08 +0800
X-QQ-mid: xmsmtpt1788351848tzmyo217w
Message-ID: <tencent_93CC3232AC6A9418BCE4372286770F91850A@qq.com>
X-QQ-XMAILINFO: N3M5peIGJjWzMxDt5MokuLIQ1zBP/tMNx0YBamqxXhtx+Qh32IkzPoS3/8r0On
	 1rDWuFFOX3D72dHB/pbmn/pmeD5khSbFgCVmArv+xKZSD3Wly9u03N8jow3CSkxPY+JjYcgvuxI1
	 +nCQ4PcCfAXUO7p/cTDT9JNBggr1/TEDVo4WtSyEdDKOVbCKWI5e/IgEhuJhFdC53JuJIxI3DGnX
	 FUmC8Tv1zWGOY1cCoSBmpgMnoSMx/Fchn0WRlN9s2m9Zh9edlmiMn4gvOvLvpS/udyGx6kURVQTz
	 9l30+wDnyGZ5dAwx0wpyi+D7gX2qnodlAsxA1G/hX0EIsxgnvySHUKIg/8H+WPE/6czUZOGHcsxR
	 sjeSe3u41XsvAvlSAv94iclK7966x1WMUqtn5WyahXuuBV7V+csOibq959OrVZfX/M1ti3coOJ48
	 JaqwWh/kWtwhJutm1qfEklO4kDmBhulKmOUnjMC2ULISQ15TyjrCIF3mrJ27UCsNxhcBmF+uA1w2
	 oqkIDjnNr70hQianJxgVLRLkPm72VF9uMkxInBMl/ZyUPHuML2Ztym6x9DD04fyRMJSJKxAQwjjq
	 jzsRB6xnYsr44ErAW9CaXgSMsyNygPKFF+upb/I+IKRQNaeGEbNHNV3tBvGQDx/5X0H82p2MV9/Z
	 o9YdIjMu9uDpAuMnBMmNhPxlcH+G8+8s44rmHwU3J8MIhkhRqxkRcSSJ7Wzdu42ziTIuSRFs7hH2
	 I2mUL4y1N3agBecFz23XBOmeF9zExPxYbuYcpNZ8xTlj8uKO7nLVDFdgzIV8k1HACjvkYCSgHhVz
	 Oy+Jj3WeB1GvBrAiM8ZEfICDaepQpZHdJ8MJQMJpxRgAKm5F6cuxgIOcnuZAB6H2zQyi++xPbI94
	 UP2IPPJiMo87n/wPzRxRl6YWt5sCmqcOibhPRyyXdW50eiKrHcZTFr8q6qNVjnsK/D6Bg2xb6dY8
	 qCANk+ogBXVxZsLEXo9DABo/YAKIJeukBwXs+aDItFj7h9+XcHj3YGA5+xlE24O/Rl9LLZ5A2tk5
	 lDPe7VtnVfk0OCl136GeDg07+hmAt0t0sH4dnrLX7BnntAdFnpVU9LeMz1QXTkUIr3Hl3qnMb2wG
	 PGqqt9
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
Date: Wed, 2 Sep 2026 20:24:06 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5] ext4: rewrite ext4_convert_inline_data_nolock to make
 it safer
X-OQ-MSGID: <apgVZm_atVxWr7tY@DESKTOP-AT5F202.localdomain>
References: <tencent_8756434A305EF41A89C387860E424A199709@qq.com>
 <tencent_FBF9C69AF090A1BF9003C68555A8928D1707@qq.com>
 <20260902102416.6FDE61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260902102416.6FDE61F00A3D@smtp.kernel.org>

On Wed, Sep 02, 2026 at 10:24:16AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> [Severity: High]
> Does initializing .not_found to 0 set up a false positive match instead of
> the expected -ENODATA?
> 
> If a filesystem image is mounted where a file has EXT4_INODE_INLINE_DATA
> set but lacks the EXT4_STATE_XATTR flag, ext4_xattr_ibody_find() will exit
> early without modifying is.s.not_found.
> 
> Because it was initialized to 0 (meaning 'found'), later in this function:
> 
>     error = ext4_xattr_ibody_find(inode, &i, &is);
>     if (error)
>         goto recovery;
>     if (!is.s.not_found)
>         error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> 
> The code believes a valid xattr entry exists at is.s.here (which points to
> uninitialized space). This causes ext4_xattr_ibody_set() to attempt to
> delete a bogus entry, potentially leading to out-of-bounds memory
> operations and a kernel panic.
Got it.
> 
> [ ... ]
> > +		struct ext4_extent newex;
> > +
> > +		newex.ee_block = cpu_to_le32(0);
> > +		newex.ee_len = cpu_to_le16(1);
> > +		ext4_ext_store_pblock(&newex, block);
> > +		path = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> > +		if (IS_ERR(path)) {
> > +			error = PTR_ERR(path);
> > +			if (error == -EDQUOT || error == -ENOSPC)
> > +				goto recovery;
> > +		} else {
> > +			ext4_free_ext_path(path);
> > +		}
> 
> [Severity: Critical]
> Does this restricted error check silently swallow fatal failure codes
> (like -ENOMEM or -EIO) from ext4_ext_insert_extent()?
> 
> If ext4_ext_insert_extent() fails due to memory pressure or I/O error, the
> restricted check allows the failure to fall through.
> 
> The unhandled error code is then overwritten shortly after:
> 
>     error = ext4_xattr_ibody_find(inode, &i, &is);
> 
> This completely masks the prior failure, causing the function to complete
> successfully. The inline data flag is cleared, but the newly allocated
> block is never added to the file's extent tree, permanently losing the
> file's data and leaking the block.
Got it.I will make the inode revert to inline data when the error is 
neither EDQUOT nor ENOSPC,but it will not free the blocks.
If the error is neither EDQUOT nor ENOSPC,freeing blocks here could 
lead to a more severe error.See the patch 
"avoid infinite loops caused by residual data"
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/tencent_FBF9C69AF090A1BF9003C68555A8928D1707@qq.com?part=1

