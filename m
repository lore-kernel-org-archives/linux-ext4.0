Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794125340;
	b=sRCRdWt/hxMjPbu0MOuJBguwbRuYETqUTVy2FCpTkJY47gaCCigs9wLq/fUR1bQ36BWJ
	 8NkVUyomgsuReb1MlKTqMJ9WRzui271iHR4fCbr1R2n417TWrDiw8ZMeFnsRzKYnqBYno
	 t0z5fu2VaeFFSvFafKQNXqn6khxxsyClD5ZuFiZzDbP9uCbvbO42LKnTC6AosA1l0sf7z
	 /gDc5XJzwjKEOs9TijUXukuhSF94Ch51/QZRUPS75ub3k+PzX+351MUxrs4Ao5MMlWnTC
	 WqQ5X6dTED5yy3IlFAc94458m0DlHcDz5/wyeq5pZ4gkDS4VHHWKXXSLmBEeBzo1mRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794125340;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=vQLqAa+irjiULq48S9gC4f/+L5vdap2DNH9SvOBPNW0=;
	b=UrJAGZHdLbkXH2miDESzzYrFOD8iD8K8H6zw1BDMfbRkeRCpgKnOjcyK6R5AEy1S2zXt
	 rcwua6A+jSA/hIUx0YB0cVuzSivWgVrQZ7utxcu6fMdNXMR4O5Bt/70EaV6i4+ykUDBGT
	 ljmHNzVNA7PJk6ideJbcx7STTFsmqEjh7vnpQ0l86ONz3Meny6uyjlmmmCFBmt5ce76D4
	 Y0VApBw4qs8qZ/f7jZ7sPkEXuzzYMbCP/Jpb4eBHF4X+St7Z39iAmWJxbZ58gXav/FQbL
	 dhfkWM+Eh+WejzEB/nbdFOYWkR9Hzx38tc24ZUixIJ2Ne+p7mlTAlKC/NbeLCDw641Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g1N2KZZJ;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625E606A331;
	Sun,  8 Nov 2026 08:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D625E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g1N2KZZJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794125340; x=1825661340;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=jSizuwADrEhB/U1cSrHvODt5z2t4L88LWP0K2OJ30LQ=;
  b=g1N2KZZJqO5ojA9chOQwf3rJfnZdEZOHmssgebqLe5yA36xPag19xuUP
   F7z9hriL+gEyxYNgNEpsSlQmKmaVGZPktKlcbOWoE/0w50tQ4dZR2tO/G
   aMVeV3IbvQWqbcVwUQENYluvhEtA8C/Na372fzQylGM2viWD2mhbg5vhP
   woE0TH1LwzO2pYPiCz+OzydxbwZF5L56Ezo2CWqZyY4gAtx6211mp570L
   w5eGWMDfbwlucqEcUQE153G61pOFijwvhFolh1kVkrRWnl3C/L7XCMSiw
   bASMjHS/kakIyxvpd2DE0f+b+OqBuwR8EOAsUi774cj7DGU4iBk3L3ExC
   A==;
X-CSE-ConnectionGUID: PPKv2+7WQBmsYh/QKQ7esA==
X-CSE-MsgGUID: wLckIptxTeC5lOVHzlPu/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11959"; a="2780123"
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="2780123"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 00:08:59 -0800
X-CSE-ConnectionGUID: p0sb2FFuRQ+VBwnPjEK7sw==
X-CSE-MsgGUID: 4MJRbDYpQSSD8bfqsEzHDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="7446611"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 00:08:56 -0800
Date: Sun, 8 Nov 2026 16:08:53 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
	yi1.lai@intel.com
Subject: [linus:master] [ext4]  7f373083b4:  fio.write_iops 54.8% improvement
Message-ID: <202611080817.b5c132ae-lkp@intel.com>
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

kernel test robot noticed a 54.8% improvement of fio.write_iops on:


commit: 7f373083b45757b19f36a939f255239d40ccfb24 ("ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: fio-basic
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	runtime: 300s
	disk: 1HDD
	fs: ext4
	nr_task: 1
	test_size: 128G
	rw: write
	bs: 4k
	ioengine: falloc
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261108/202611080817.b5c132ae-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/ext4/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  6585cea3cf ("ext4: allow ext4_map_blocks() to start its own transaction handle")
  7f373083b4 ("ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents")

6585cea3cf58b8e8 7f373083b45757b19f36a939f25
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.08 ±  5%      -0.1        0.02 ±  4%  fio.latency_2us%
      0.05 ±  2%      -0.0        0.02 ±  5%  fio.latency_4us%
     27.91           -34.9%      18.16        fio.time.elapsed_time
     27.91           -34.9%      18.16        fio.time.elapsed_time.max
     17.90           -46.7%       9.54        fio.time.system_time
      3013           -34.2%       1984        fio.time.voluntary_context_switches
      4758           +54.8%       7366        fio.write_bw_MBps
    648.00           -44.7%     358.67        fio.write_clat_90%_ns
    652.00           -44.4%     362.67        fio.write_clat_95%_ns
    664.00           -43.9%     372.67        fio.write_clat_99%_ns
    632.44           -43.9%     354.58        fio.write_clat_mean_ns
   1218093           +54.8%    1885792        fio.write_iops


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


