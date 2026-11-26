Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795673432;
	b=WLzWfP1hcjgLoPfNnU7TyczXjlSjYE+tRy3nfOhgtLSP+YxzxsjS5FGUPy7PuQQNETHL
	 sUWfAPvHc6rTaCTfvAMXs5qzj3NTRvapTZRweKfnF6oFRgstmCzHbX24tYOPZQ2JE5za5
	 6Gg58aK41JKP2/sRbfCF3xciqEmKHzx5ACzX07F4Fs0q1SsFdM6+4mQ0wLHRe6H2mBKRO
	 mmDk3M0KExaTMY0ZJbaK4FDuXGbpdQwXGFR7dW57uzy7RhdmkZH4eZunLUKvbdJ8o4Wdx
	 DxJMncC0DDHNnDomE7MK8JEnBAPbfbHUd7LovxYhURdvEQd9eKzuxi0fqXUFV6nQxMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673432;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:
	 References:CC:From:Message-ID:Date:User-Agent:MIME-Version:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=IcetfdoRKNR8FtUGcW2x6r/UOCI+tBFsbCZVryMFgmg=;
	b=CU7Csn15l912xhd4BvHRioLJDKAzgDvDofE8I65v7a7gTGWGZ4fzsfCb+wKGsaUgKsmg
	 GlF8BKa+XplSdJnhHeITJUlqK6hbYDu3WgxzfL8EXjPC0ydbY/pfjgqHxbIl/CdFAamka
	 2jBERDBuuklBR3IjWvRdk3NaMajmtuj/HiLdIlbR3n9grdVaIvSnk1kWE5l/uDl8erv5g
	 +fsaGI11RImVJzxJi0HIJlyYW42Zq18WSHnhhNBJYiJC47gHVDxxl0DEoo4vz1Nz73vZc
	 XfF1gaTNR3bEkf7OKKiAvsrfCv6ADyGV+bEkR09mqP6WPDqt41gRHT+vM02PPHhLNew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=if94YbtC;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BE8606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 06:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66BE8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=if94YbtC
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IcetfdoRKNR8FtUGcW2x6r/UOCI+tBFsbCZVryMFgmg=;
	b=if94YbtCaLuvsWH2fPftRmt7hmV5YqGY11955FL/uPSWnw32Pwik/aA5XUrfnrj1dJ9zA64Um
	oTjpybe8m59rB82LnFkkAzrh7vzWff0ZpTsemR3sFfJ9jZHDltUgRN6Ci9hT6fMoP7j6HspDnPS
	P7ADo5Oe7lxTP9lTP+mFuos=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jZmN50G4wz1T4Ln;
	Thu, 26 Nov 2026 14:09:25 +0800 (CST)
Received: from kwepemk300010.china.huawei.com (unknown [7.202.195.128])
	by mail.maildlp.com (Postfix) with ESMTPS id F2B094057F;
	Thu, 26 Nov 2026 14:10:15 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemk300010.china.huawei.com (7.202.195.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 26 Nov 2026 14:10:15 +0800
Subject: Re: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
To: kernel test robot <lkp@intel.com>, Ye Bin <yebin@huaweicloud.com>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
References: <20261125111055.3672233-3-yebin@huaweicloud.com>
 <20261126015002.1lcIDaq1-lkp@intel.com>
CC: <oe-kbuild-all@lists.linux.dev>, <jack@suse.cz>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <6B07CD46.8060109@huawei.com>
Date: Thu, 26 Nov 2026 14:10:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261126015002.1lcIDaq1-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300010.china.huawei.com (7.202.195.128)



On 2026/11/26 1:58, kernel test robot wrote:
> Hi Ye,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on tytso-ext4/dev]
> [also build test ERROR on linus/master v7.4-rc4]
> [cannot apply to brauner-vfs/vfs.all next-20261124]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Ye-Bin/quota-Forbid-Q_XGETQUOTA-and-Q_XGETNEXTQUOTA-for-frozen-filesystem/20261125-191054
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> patch link:    https://lore.kernel.org/r/20261125111055.3672233-3-yebin%40huaweicloud.com
> patch subject: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261126/20261126015002.1lcIDaq1-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126015002.1lcIDaq1-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261126015002.1lcIDaq1-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>     fs/ext4/super.c: In function 'ext4_write_dquot':
>>> fs/ext4/super.c:7165:13: error: 'freeze_protected' undeclared (first use in this function); did you mean 'freeze_processes'?
>      7165 |         if (freeze_protected)
>           |             ^~~~~~~~~~~~~~~~
>           |             freeze_processes
>     fs/ext4/super.c:7165:13: note: each undeclared identifier is reported only once for each function it appears in
>

This is a bit strange. The ext4_write_dquot() function hasn't been modified at
all, and the nearby functions don't seem to have been changed in the latest
version either. It's possible that the patch wasn't generated based on the
latest linux-next code, causing git to apply the patch incorrectly by matching
only the context and line numbers, thus targeting the wrong function. I'll
regenerate the patch and send a new version, and I'll also CC linux-fsdevel
this time.

>
> vim +7165 fs/ext4/super.c
>
>    7144	
>    7145	static int ext4_write_dquot(struct dquot *dquot)
>    7146	{
>    7147		int ret, err;
>    7148		handle_t *handle;
>    7149		struct inode *inode;
>    7150	
>    7151		inode = dquot_to_inode(dquot);
>    7152		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
>    7153					    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
>    7154		if (IS_ERR(handle))
>    7155			return PTR_ERR(handle);
>    7156		ret = dquot_commit(dquot);
>    7157		if (ret < 0)
>    7158			ext4_error_err(dquot->dq_sb, -ret,
>    7159				       "Failed to commit dquot type %d",
>    7160				       dquot->dq_id.type);
>    7161		err = ext4_journal_stop(handle);
>    7162		if (!ret)
>    7163			ret = err;
>    7164	
>> 7165		if (freeze_protected)
>    7166			sb_end_intwrite(dquot->dq_sb);
>    7167	
>    7168		return ret;
>    7169	}
>    7170	
>
