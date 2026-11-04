Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756104;
	b=oo6CVOzRhu2ZLQyZn/ZWijc0VDqIwpKYRjKyKmvrYtvkLO+qpTI57jS3TawWcWbVHCIH
	 dgbFRPM2yTeCPR84wUXyAxVpxRHGYEjgTVJPrbunI40/48FAPKsdaK+jnwN502icQQmL6
	 qXCS1lFIzwC09C70HijGUL1c7SsXV11Uj4jvHpVid3EeTs0CErSiw7QzBuRQFtEqzTek2
	 S+Rbrnr2vHrzsgM1WYDlYOXAa1FOtg/taSytuSb4lnZmjcGi8TbFsQi3HylA0BiaRDcfG
	 NTi0udLtK3Q5ZS+N6Gyj+a2YyYskLLKNiTorN6ap5ero107lAZx9cWDPA6rselYzWQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756104;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=Eg/S+vREecV5RoaeGFwVZ2OmjaALE5RxcdFFaRC7bKM=;
	b=HXkSd0a6sxVQpt2uo7g/1Ob/6dwIV2kd9vHUfKY4kX0VGfW9a0FU+NuOmZPCEpFwS2nn
	 xxUkgyM8loBL3m4tvRpqChNYXWySPvUdc1KekXxTQ03s5HPZ/7lxWi6khZxmV6aOOOCJE
	 ktaiIPcWd4M59VWc8VxgVMeZukjTrpaZbSH4ennOeqknpMgW7SXmxCIhBlobqsdPOvRZ1
	 GLB1ChloGVkIWCh5Biz2bHOowmji5znu/kog7x5o5rVgQx7djd6J4ero5MhQenr2+XeB+
	 JilkFa+7wjEWK1KegsVChGSFvIXCH8vnuBpnPkBJzKVzPVtkVXM8ku+FTLnotV098XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iUuna0c+;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB86606A326;
	Wed,  4 Nov 2026 01:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AB86606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iUuna0c+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793756103; x=1825292103;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=tVSMDNJleH2QUM1diHCRuVVlKfeFaZ7YlVwLQnoBD9M=;
  b=iUuna0c+TqNMFdNM62cOhmb/6aZRSqfZk5Kp5imYz9L19iHv++iFJ64K
   lXBc6ZaY3tih2prY+ycieIldhNSvUHhyobvoaQwQ5V2QVaW4jl1pTMqJL
   G2aaREjzUCFbCoKuHNZWiqM3bsmWbGeM9F4gwXoHX0r/yVCy0nemoki1x
   jusmeXq7aDv1ZmOHpQXtygKMDiQ/4XLYXBMQFEXd5A0YeLsIgpm2MSmp8
   vxiT3MYhcF03qCHYkLnbEuWuJMM917KQmTGJvWi1EcouIzZdclXfNJqpJ
   Bz8EAGbcFc6oFC3e9gZNIuOR1NQ22D6Uf4PE0UuKd8CUD5AR26SuQd+G2
   w==;
X-CSE-ConnectionGUID: nFFE7Gt0Q/ewbTukBs1h0Q==
X-CSE-MsgGUID: U+bEc/5SSSyd+RcLh0RLxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2401028"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2401028"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 17:35:02 -0800
X-CSE-ConnectionGUID: 9dlUZcGxQO2Nq7Ibx/dttA==
X-CSE-MsgGUID: dkvvnlCXRjSUGfPquWZwfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="8446661"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 17:35:00 -0800
Date: Wed, 4 Nov 2026 09:34:57 +0800
From: kernel test robot <yi1.lai@intel.com>
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	yi1.lai@intel.com
Subject: [linus:master] [jbd2]  b5501f970d:
 fxmark.ssd_ext4_dbench_client_32_directio.works/sec 5.7% improvement
Message-ID: <202611040245.a26ace73-lkp@intel.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit



Hello,

kernel test robot noticed a 5.7% improvement of fxmark.ssd_ext4_dbench_client_32_directio.works/sec on:


commit: b5501f970dbc039df1f7c720b7a481b62de125cd ("jbd2: avoid false sharing with j_state_lock") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: fxmark
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 2c
	disk: 1SSD
	media: ssd
	test: dbench_client
	fstype: ext4
	directio: directio
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261104/202611040245.a26ace73-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/directio/disk/fstype/kconfig/media/nr_threads/rootfs/tbox_group/test/testcase:
  gcc-14/performance/directio/1SSD/ext4/x86_64-rhel-9.4/ssd/2c/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/dbench_client/fxmark

commit: 
  4a87cfb9b4 ("ext4: convert group-count barrier protocol to acquire/release")
  b5501f970d ("jbd2: avoid false sharing with j_state_lock")

4a87cfb9b45ae07c b5501f970dbc039df1f7c720b7a
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    176.50            +7.0%     188.87        fxmark.ssd_ext4_dbench_client_32_directio.iowait_sec
      2.70           +13.7%       3.06 ± 18%  fxmark.ssd_ext4_dbench_client_32_directio.softirq_sec
    128.43            +6.9%     137.23 ±  2%  fxmark.ssd_ext4_dbench_client_32_directio.user_sec
     11759            +5.7%      12432        fxmark.ssd_ext4_dbench_client_32_directio.works/sec
  2.98e+08            +5.8%  3.153e+08        fxmark.time.file_system_outputs
    108.65            +7.4%     116.70        fxmark.time.user_time
   6468008            +5.2%    6803995        fxmark.time.voluntary_context_switches


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

