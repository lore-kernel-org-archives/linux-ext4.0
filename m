Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554271;
	b=Kh6Bl7mBMXKr0rrCM21d5MHhpRrV6YSuCv+FcLAA51hOasYpQ7tzbE5cdh5xc3oVvb5f
	 xWZE2OHRGaEFE4nbZaqCgIM7YyerOOV5v8dX5Y2QMfhbvuRZqRptpMyXSREOb2OGFFRzv
	 V8iMZmt2AQnFx2pn6bg/w9WrAr2DM3x+6aLtNTCQomSxwRrsK3PgY+yBZUE/Ni33kcIHZ
	 eH3J0z4D0JexgO2kbYsxGqWLUDIrW841JSoFq9hCSRZv891BxikGexpidZn7Yxa/9LJa9
	 pn+ChPXWumoBidsB0u3SuigxVxiPibjyWIRDPjTekoe/eo0c0ZBNtAkTH6OpHXk1p4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554271;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=fV5WOnFWS4qmlmCQnN6uviVor4/nC4eX1sEtnmtdKiU=;
	b=lh8SmU2cbfoBzZfVAMep8OR/kpmgP9YmFLONnlXpcMBGA/kIymZSSTM8GB/uEtol54KD
	 hF+cw0t8pNdYadSqBt16c3D6pkme2wL0K85iTJ3P/gbHLc1JnrmlSdMEyeqGwqtN6bMVE
	 UkjIGSBff7Gs00Sh6iSZc6/uwt0p2hU1Xn0iRkFp10vpGK2e4hShMeEpLSLjrmRPGnNjF
	 GifuBxEH4k1DrTmrx68k0V5dV8+f+k/wLTuXzrGBAo9IyKDp3NZbDZsa8qv/9QBAld6c5
	 2LmVvyw5wUt28BVfd5xLAExDkxTgu+G+O7UHEd7RRn+KOC33K1DJ5y4opPcGF5gWENw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=cryspen-com.20260707.gappssmtp.com header.i=@cryspen-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b4McKKtZ;
	arc=none smtp.remote-ip=74.125.225.139
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA4D606A327
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEA4D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cryspen-com.20260707.gappssmtp.com header.i=@cryspen-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b4McKKtZ
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-4a611dcb60dso1112065e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 23:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryspen-com.20260707.gappssmtp.com; s=20260707; t=1794554269; x=1795159069; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fV5WOnFWS4qmlmCQnN6uviVor4/nC4eX1sEtnmtdKiU=;
        b=b4McKKtZKgWe+40ufnv8JvoVKOSovOh0FXXdYazUdaI4imy8ZJefHbNLOzPEelnwi0
         Ppxc/WrPjIMAXqF0x3qm5IJxS4hmncGttxr91kVKiUjrk8DaAvoVdZLc4noaYxsWaO5R
         88NPdS+bxxC7+UuInd6aYCDD+UmT1wkjrLb6zcmANUoTo4TC0J+o5p/WazVtkXvfwNLf
         y3keS10Ih/WYolw3EDW/eDW1JPty4ur3QZpNOkurSZfuSGDXfeMe1DMaFiR/AjUxiYTm
         1A3sYtlOhF3OUghlOFYYvNFSqHdxjcr49J5Ug6rpUsqSLEXAhm9MDQ1vss0AwaEi7KcV
         6kaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794554269; x=1795159069;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fV5WOnFWS4qmlmCQnN6uviVor4/nC4eX1sEtnmtdKiU=;
        b=n++G/+CjtjZ42/BwxnZUssCZ6jwyYYue9ysstFUB/xMqNTuZ5EOvPmgck0nRKrkZmH
         Ah90BtZdc8DuVLupRfiLLCksND1q5tsnDlIfgwG2AYkGzWVZwSTnHRc5BJZ+ejgXKeDx
         ITpu1Zv4Y+ioV9bzTD0DdwtMWw8mWk1VW8TK6lQjAip9hZ93QJOTC3jkPbvUfmKpSodL
         M1F3i2RXwHBbZ2GUnB1761VYF0PcAFAg0tcu63J/pX7TY9oq3/nQgl8Klf2MSq7ZSJWa
         kH21XV3ekELotBmyh/sg4tlwzvuF6FZ7EBTqTC+JHwpj/pGpUnZUFc4PN74jI/dVVHcl
         4ljQ==
X-Forwarded-Encrypted: i=1; AL+hErHwepnKdmo3B/U7TDoSu+f0I3tIVjMcDmawdNCZ0tWPjcR00fvruANLLL06IUUeEYYKSyxDMuGsogK/@vger.kernel.org
X-Gm-Message-State: APuU4Z8FAGtExIYiWMDaJ5utri7TOU4lwJddlrALPXCvH5R+Ey94xFJ+
	6vfA3BylxDLYfGa8NHGRkPv3VfAj/xOEWVAyo5v5Yf05XZm84Lokd+4Vp/ST/HmwfKU=
X-Gm-Gg: AYBFou1f1d7nXEPqdSeCr2Bvf1shLxeuFWiDAqMAlOeVtIovA0Edqd5s8/LGevdHC2e
	Mn2Dvy+Gf5NqDJ83QrdwT/9OwQDCFrZR+bk538YZ6ft6ZndPcT+qi3djY4wTzjMi9XupYzIM2pG
	qxjuTOlVR6xhyZURjutmvT7JC3PTO4mltTf/Vf72IPxQ7hRyzRKOrR7gOhYrK0wFCe5Cwi2wMNi
	HaWEDB1P/flCCnaOMY45xCGYVGNklRuBw3MP1JgyknDMPUxxx4zNnVPV30bZfr6mNtVvFHaKdl7
	tB4Q527lcyw2oxT/eNWqSLAwMSWtZ6Hn/qwzCpEvSW3NvYzu0bffITd5h/hcwprdaPAEjFsWgFL
	FQEBpnB/8wf1kcMPnaS57ri9Bv5Kf60kjPJ3jiGYMt3S0+lWWrJ0X0Yl2ePu5KEpScQxQGiRY1m
	AH1E1Z8WpakUJDHhX5BNmF3rsLPsxh0gxTIXi0uqZU7tVlr1s1PNKcBjWFPEMdL8V3yqkJI495J
	zQV1h0ohBmAkC44ZqHoYDJ1HqgPGXo3aZ/mj1EMmpg+nQf5jjdijBs8rMwr+qJaD10H5JTjklQJ
	ebgmfNg3C6wCx0ALBkkHaJ9dHg==
X-Received: by 2002:a05:600c:37c4:b0:4a1:ddca:8b66 with SMTP id 5b1f17b1804b1-4bb55ae3e0emr28650625e9.31.1794554268906;
        Thu, 12 Nov 2026 23:17:48 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55a0ffcdsm38845155e9.0.2026.11.12.23.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:17:48 -0800 (PST)
From: Dan Carpenter <dan@cryspen.com>
X-Google-Original-From: Dan Carpenter <error27@gmail.com>
Date: Fri, 13 Nov 2026 10:17:45 +0300
To: oe-kbuild@lists.linux.dev, Theodore Ts'o <tytso@mit.edu>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 13/50] fs/ext4/orphan-test.c:855 orphan_test_init()
 error: 'sb' dereferencing possible ERR_PTR()
Message-ID: <202611121755.hiQrKm5X-lkp@intel.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git pu
head:   246d715a48c25a74ac372dda5e10d8f69f89b50a
commit: 8a129f6ffb7e1892ce3c84ba50e50f0f1049383f [13/50] ext4: add KUnit tests for fs/ext4/orphan.c
config: powerpc-randconfig-2200-20261112 (https://download.01.org/0day-ci/archive/20261112/202611121755.hiQrKm5X-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202611121755.hiQrKm5X-lkp@intel.com/

smatch warnings:
fs/ext4/orphan-test.c:855 orphan_test_init() error: 'sb' dereferencing possible ERR_PTR()

vim +/sb +855 fs/ext4/orphan-test.c

8a129f6ffb7e18 Theodore Ts'o 2026-11-06   812  KUNIT_DEFINE_ACTION_WRAPPER(orphan_test_cleanup_action, orphan_test_cleanup,
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   813  			    struct orphan_test_ctx *);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   814  
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   815  static int orphan_test_init(struct kunit *test)
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   816  {
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   817  	struct orphan_test_ctx *ctx;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   818  	struct fs_context *fc;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   819  	struct super_block *sb;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   820  	struct ext4_sb_info *sbi;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   821  	struct inode *root_inode;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   822  	ext4_group_t g;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   823  	unsigned int bit;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   824  	int err;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   825  
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   826  	ctx = kzalloc_obj(*ctx);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   827  	KUNIT_ASSERT_NOT_NULL(test, ctx);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   828  	test->priv = ctx;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   829  
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   830  	ctx->bdev.bd_stats = alloc_percpu(struct disk_stats);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   831  	if (!ctx->bdev.bd_stats) {
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   832  		kfree(ctx);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   833  		KUNIT_FAIL_AND_ABORT(test, "failed to alloc bd_stats");
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   834  	}
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   835  
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   836  	fc = fs_context_for_mount(&orphan_test_fs_type, 0);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   837  	if (IS_ERR(fc)) {
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   838  		err = PTR_ERR(fc);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   839  		free_percpu(ctx->bdev.bd_stats);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   840  		kfree(ctx);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   841  		KUNIT_ASSERT_EQ(test, err, 0);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   842  	}
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   843  	sb = sget_fc(fc, NULL, set_anon_super_fc);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   844  	put_fs_context(fc);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   845  	if (IS_ERR(sb)) {
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   846  		err = PTR_ERR(sb);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   847  		free_percpu(ctx->bdev.bd_stats);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   848  		kfree(ctx);
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   849  		KUNIT_ASSERT_EQ(test, err, 0);

Of course err will never be zero, but this condition is an unreadable
way to ASSERT() failure...  Smatch tends to ignore these sorts of
asserts where a complicated condition ends up being always true on
the basis of, "I probably parsed this wrong if people are checking it".

8a129f6ffb7e18 Theodore Ts'o 2026-11-06   850  	}
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   851  	ctx->sb = sb;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   852  	sbi = &ctx->sbi;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   853  
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   854  	sbi->s_sb = sb;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06  @855  	sb->s_fs_info = sbi;
                                                ^^^^^^^^^^^^^
Warning.

8a129f6ffb7e18 Theodore Ts'o 2026-11-06   856  	sb->s_op = &orphan_test_sops;
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   857  #ifdef CONFIG_QUOTA
8a129f6ffb7e18 Theodore Ts'o 2026-11-06   858  	sb->dq_op = &orphan_test_qops;

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

