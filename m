Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5A3E51EC
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142430; cv=none; b=M/pEifit9kU3MX2tSRg/q9rBR38dn+vCt6Ry74iIJDZ6jQS6muYJRcLhfRu+Rb+EX+NxDUAkL6dbY4L6ZZnosWRjYAb/H996oTSEl1/aWbJzxFeuSig9Vf0IIrx603/BIDGIlzPWp56FJ2K52TyloyOPyamNsBa4InVDakmcWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142430; c=relaxed/simple;
	bh=Hn+HkZil0eVjvq1oQ8H5orTMwbOMJhgXlw2fGbTw7MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d3H6zKkPcIvbIKdyZVA1xTjRr8z65YHcOmAya9VR4053peKmQ0EHwSf4roo2sUbNMoE9v1bSkeyQWBaCVsCHq1UnNDCRtTu9vOXhVaWN1i+HwYr/Mv0zBbGVmrc7KmaesTQzVJzsQ1DxOFJuc20mDWLcaeutDGDp2HsPbD8sllM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j5fYJ5ZC2zKHMlg
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 17:20:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BB5CF4058D
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 17:20:23 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu1T7NFqy6qVAg--.19047S3;
	Fri, 16 Oct 2026 17:20:21 +0800 (CST)
Message-ID: <8bacf39d-5a1d-404d-ad58-0bf76c8ae891@huaweicloud.com>
Date: Fri, 16 Oct 2026 17:20:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [tytso-ext4:dev 40/41] fs/ext4/inode.c:4518
 ext4_iomap_writepages() warn: missing error code? 'ret'
To: Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
 linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
References: <atHZN9YIl8T2E0tK@stanley.mountain>
 <1165ce1d-6485-4b70-9949-47ee071a0a22@huaweicloud.com>
 <atHo7i5Uq9cdeVFt@stanley.mountain>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <atHo7i5Uq9cdeVFt@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXTu1T7NFqy6qVAg--.19047S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw15AF1rGr48Ww4rXr4DCFg_yoWrXw4rpF
	yxua4kJF4Iqa9IkFyv934DJa18Ka4kCr4rJry8Cr4fZFyrZrZ7Gr129FZ2gF1Ygw1DGrW7
	AF4YkrZ5J34UAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/16/2026 5:05 PM, Dan Carpenter wrote:
> On Fri, Oct 16, 2026 at 04:49:10PM +0800, Zhang Yi wrote:
>> On 10/16/2026 3:58 PM, Dan Carpenter wrote:
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
>>> head:   8c4f6e3376348fc3162eed86a05b933921c8f9ed
>>> commit: bdcbb0f19e921c7ea3241f55922032dff23d1d26 [40/41] ext4: partially enable iomap for the buffered I/O path of regular files
>>> config: x86_64-randconfig-2200-20261016 (https://download.01.org/0day-ci/archive/20261016/202610160314.PLMEXaOJ-lkp@intel.com/config)
>>> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
>>> smatch: v0.5.0-9187-g5189e3fb
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Reported-by: Dan Carpenter <error27@gmail.com>
>>> | Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
>>>
>>> New smatch warnings:
>>> fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'
>>>
>>> vim +/ret +4518 fs/ext4/inode.c
>>>
>>> a304299a40d92c Zhang Yi 2026-10-09  4488  static int ext4_iomap_writepages(struct address_space *mapping,
>>> a304299a40d92c Zhang Yi 2026-10-09  4489  				 struct writeback_control *wbc)
>>> a304299a40d92c Zhang Yi 2026-10-09  4490  {
>>> a2e096bf59634f Zhang Yi 2026-10-09  4491  	struct inode *inode = mapping->host;
>>> a2e096bf59634f Zhang Yi 2026-10-09  4492  	struct super_block *sb = inode->i_sb;
>>> a2e096bf59634f Zhang Yi 2026-10-09  4493  	long nr = wbc->nr_to_write;
>>> a2e096bf59634f Zhang Yi 2026-10-09  4494  	int alloc_ctx, ret;
>>> a2e096bf59634f Zhang Yi 2026-10-09  4495  	struct iomap_writepage_ctx wpc = {
>>> a2e096bf59634f Zhang Yi 2026-10-09  4496  		.inode = inode,
>>> a2e096bf59634f Zhang Yi 2026-10-09  4497  		.wbc = wbc,
>>> a2e096bf59634f Zhang Yi 2026-10-09  4498  		.ops = &ext4_writeback_ops,
>>> a2e096bf59634f Zhang Yi 2026-10-09  4499  	};
>>> a2e096bf59634f Zhang Yi 2026-10-09  4500  
>>> a2e096bf59634f Zhang Yi 2026-10-09  4501  	ret = ext4_emergency_state(sb);
>>> a2e096bf59634f Zhang Yi 2026-10-09  4502  	if (unlikely(ret))
>>> a2e096bf59634f Zhang Yi 2026-10-09  4503  		return ret;
>>> a2e096bf59634f Zhang Yi 2026-10-09  4504  
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4505  	/*
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4506  	 * Submit the pending zeroed EOF block range if the entire
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4507  	 * writeback range lies beyond it.
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4508  	 */
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4509  	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
>>> 53fe71a6bcad0f Zhang Yi 2026-10-09  4510  
>>> a2e096bf59634f Zhang Yi 2026-10-09  4511  	alloc_ctx = ext4_writepages_down_read(sb);
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4512  	/*
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4513  	 * Does ext4_change_inode_journal_flag() change the inode's
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4514  	 * buffered I/O path?
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4515  	 */
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4516  	if (!ext4_inode_buffered_iomap(inode)) {
>>> bdcbb0f19e921c Zhang Yi 2026-10-09  4517  		ext4_writepages_up_read(sb, alloc_ctx);
>>> bdcbb0f19e921c Zhang Yi 2026-10-09 @4518  		return ret;
>>>
>>> Either return 0 or an error code here, but not ret.
>>
>> Thanks for pointing that out, but this is a false positive. No error
>> code needs to be set here. This path is only taken when the writeback
>> races with a concurrent journal flag switch, and since the switch will
>> write back all dirty data, there is nothing to be done for the leftover
>> writeback here and we can just return directly. So the 'ret' will simply
>> be 0 here.
>>
> 
> Yes, please change it to "return 0;" so it's more readable.
> 
> regards,
> dan carpenter

Sure, I'll send a separate patch for this.

Thanks,
Yi.


