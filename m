Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A34582E8
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141557; cv=none; b=iM7qe3xsmIusZu2RJsiAiaznaI3Jt1VEmtcBwmW98ZmiI/P8MzCcWpa82AbBkCVRpBILWC60dLb4awIxKg8u3ttFROFMc7d8DRQm/CzaOVfL+FY0ue+B1FYfhtlFG966htMt8CIWJBdxnZ53e5D5JrsH4OmUzQCO0FJqULKuEOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141557; c=relaxed/simple;
	bh=ktmGE4VloINH0t2kS1qwYQBSbNlThF5dw7Auq437liA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clAQWRYy9xRCEW3oT5Ze5LUiFUJStIlGDQbI3v6oSWZZxUILZKFbvsGbXyVyuflUR5M7rop0Mvut8C984i7K3dg4NFF6eBheWTr/AjxJ8yYMEAlzzbzUmkMpSsSvAFTE2SmiMUfPho8yNURU7Sc0c6i0VhBAxQRlU9rSKkNY9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DAZZZp9S; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DAZZZp9S"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c4d870d54so3919318f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 02:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792141555; x=1792746355; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0tgD6olnHpkMAt+n5CbhLUN6iepvpEnWn3HXhAZyJ80=;
        b=DAZZZp9SsA4v2mw8Rwy1kOQ4U3D9WX0pqPb/qLIUsHGlhI3i3rDhd/53qo6gszckHY
         Ri6veCuqobh/pVJVSZS2YDvEQVovAmCPm2FxgekscmgFv3leG93JDImUv2e0Y7gxgIf+
         W2VxxzFlY3+WZyrVVcygaAzK7mB/44VhaDl6JBg0FY3azOnFvkHgHtq88QtMT11nOaqw
         BDkHAs7tVo7kI6l1Ix935Y7jsnQGOvhvCWrY0GNCXaFhqesu9zz0CYcah2DYrtqJLDnC
         vwuXfk6GSf+/HxjJs4Nf9HLAPplopWZwOif83yWR6oI9KLIGBMyTfljDmtTgUkY7iTrU
         9JIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792141555; x=1792746355;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0tgD6olnHpkMAt+n5CbhLUN6iepvpEnWn3HXhAZyJ80=;
        b=SNe8AxnCFcsTBT5D/GKUGOb1klFkI1lqSSNYm8eH4hN6UzbC1kYjKes6ZLe2gvbmjl
         yhkUFTN0RZ/ZdkcmhgyQ7dn1QpRYpCm1EYBZLzi7Fk30UK8a5UWOtQGihGVDSUGpTFym
         SH8dzuzpBJSOHCdI18al3Omth5vaWNTiaPp+/ndZ0bo18poYtPHpOWDON9AVC/nu47NJ
         Frm/U4k9zkvm9AYAjALmJLxJ5CKdQe1OUpu3A3Lnl/yilaFOfmJG5Ld/SBL07Ig24Cud
         IbQp1cEmN5GEcnnSf7YUydhhSGZGmZbKmZXSEBzN15GiI8FXsIZ9Vkd+hkmhvpKnEKiG
         wgWg==
X-Forwarded-Encrypted: i=1; AKwUvByTI/+j11bQ92dyeUdaid+CxQi6uvN8Oq2DZsgiSMgsoKd2aFyimTteB2wj5VWBqM/EPe7sFQT/jUpJ@vger.kernel.org
X-Gm-Message-State: AFq9FYISersHbkI9zVORWXuRb6vsTpbl+lr17THNRx2oyPTkq7wUcleV
	lAXhCdej0NAg24BuSrGslwBo1HyQockhMO19d0Y+OAtOMdbJPJZjHp4eKkzG1XwVA5VWQA==
X-Gm-Gg: AYBFou1upts5SJwoo/+d+wAE5Zs3PPrxQyJ9ONyL95HugTxSabDQVRs/JOEciLEZQxt
	ZCe+AzERsF/mFJYo/oYOxgpF72fkqiXanYhIvZjuQzH3d26+06WWiMAxUva471s9fyzzbbx0th0
	+BU7s7Y7JsPU5W1s9s57pRhCykcVAps+W8Bt45i3xHyL+NBBpEIU70dWx7Ppnd5E3CMiTj2X15h
	xtRW9ZMXYN/y4ud18aKSBFqkC7xue7pGSTSdpbLIVuPF+LMO4A5v+j3KpvzFp5J39Vw1xmLJU7Q
	IHwEwnuo/otQGkcMn+dDmVHPo//9seoHgZV8H/V8SxeVOJt0OgduTgWsYHZ9YwqFPQpAH/YzaZW
	wSdqTRQFGEOKIe8hTp88zJM2Z0lbN6qzScGlAAUHaNUJTqPDU09J9D8v6ncVNo1Hc26/865+4aO
	JVdnHYYO3ww9wFvXiR98BXXRuqokGDJv6seQ4NTX4QYNi557PAgXFlEZrhwZqV05YaJGpLDADcE
	bs0wTw=
X-Received: by 2002:adf:e013:0:20b0:488:79d6:a4a6 with SMTP id ffacd0b85a97d-48dba7b3fefmr30865619f8f.8.1792141554482;
        Fri, 16 Oct 2026 02:05:54 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd510d60sm3577318f8f.58.2026.10.16.02.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:05:53 -0700 (PDT)
Date: Fri, 16 Oct 2026 12:05:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [tytso-ext4:dev 40/41] fs/ext4/inode.c:4518
 ext4_iomap_writepages() warn: missing error code? 'ret'
Message-ID: <atHo7i5Uq9cdeVFt@stanley.mountain>
References: <atHZN9YIl8T2E0tK@stanley.mountain>
 <1165ce1d-6485-4b70-9949-47ee071a0a22@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1165ce1d-6485-4b70-9949-47ee071a0a22@huaweicloud.com>

On Fri, Oct 16, 2026 at 04:49:10PM +0800, Zhang Yi wrote:
> On 10/16/2026 3:58 PM, Dan Carpenter wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> > head:   8c4f6e3376348fc3162eed86a05b933921c8f9ed
> > commit: bdcbb0f19e921c7ea3241f55922032dff23d1d26 [40/41] ext4: partially enable iomap for the buffered I/O path of regular files
> > config: x86_64-randconfig-2200-20261016 (https://download.01.org/0day-ci/archive/20261016/202610160314.PLMEXaOJ-lkp@intel.com/config)
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > smatch: v0.5.0-9187-g5189e3fb
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
> > 
> > New smatch warnings:
> > fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'
> > 
> > vim +/ret +4518 fs/ext4/inode.c
> > 
> > a304299a40d92c Zhang Yi 2026-10-09  4488  static int ext4_iomap_writepages(struct address_space *mapping,
> > a304299a40d92c Zhang Yi 2026-10-09  4489  				 struct writeback_control *wbc)
> > a304299a40d92c Zhang Yi 2026-10-09  4490  {
> > a2e096bf59634f Zhang Yi 2026-10-09  4491  	struct inode *inode = mapping->host;
> > a2e096bf59634f Zhang Yi 2026-10-09  4492  	struct super_block *sb = inode->i_sb;
> > a2e096bf59634f Zhang Yi 2026-10-09  4493  	long nr = wbc->nr_to_write;
> > a2e096bf59634f Zhang Yi 2026-10-09  4494  	int alloc_ctx, ret;
> > a2e096bf59634f Zhang Yi 2026-10-09  4495  	struct iomap_writepage_ctx wpc = {
> > a2e096bf59634f Zhang Yi 2026-10-09  4496  		.inode = inode,
> > a2e096bf59634f Zhang Yi 2026-10-09  4497  		.wbc = wbc,
> > a2e096bf59634f Zhang Yi 2026-10-09  4498  		.ops = &ext4_writeback_ops,
> > a2e096bf59634f Zhang Yi 2026-10-09  4499  	};
> > a2e096bf59634f Zhang Yi 2026-10-09  4500  
> > a2e096bf59634f Zhang Yi 2026-10-09  4501  	ret = ext4_emergency_state(sb);
> > a2e096bf59634f Zhang Yi 2026-10-09  4502  	if (unlikely(ret))
> > a2e096bf59634f Zhang Yi 2026-10-09  4503  		return ret;
> > a2e096bf59634f Zhang Yi 2026-10-09  4504  
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4505  	/*
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4506  	 * Submit the pending zeroed EOF block range if the entire
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4507  	 * writeback range lies beyond it.
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4508  	 */
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4509  	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
> > 53fe71a6bcad0f Zhang Yi 2026-10-09  4510  
> > a2e096bf59634f Zhang Yi 2026-10-09  4511  	alloc_ctx = ext4_writepages_down_read(sb);
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4512  	/*
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4513  	 * Does ext4_change_inode_journal_flag() change the inode's
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4514  	 * buffered I/O path?
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4515  	 */
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4516  	if (!ext4_inode_buffered_iomap(inode)) {
> > bdcbb0f19e921c Zhang Yi 2026-10-09  4517  		ext4_writepages_up_read(sb, alloc_ctx);
> > bdcbb0f19e921c Zhang Yi 2026-10-09 @4518  		return ret;
> > 
> > Either return 0 or an error code here, but not ret.
> 
> Thanks for pointing that out, but this is a false positive. No error
> code needs to be set here. This path is only taken when the writeback
> races with a concurrent journal flag switch, and since the switch will
> write back all dirty data, there is nothing to be done for the leftover
> writeback here and we can just return directly. So the 'ret' will simply
> be 0 here.
> 

Yes, please change it to "return 0;" so it's more readable.

regards,
dan carpenter

