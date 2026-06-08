Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219C1378833
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920114; cv=none; b=Dd+oNr7XkYurVeds81S5Cl5bBkE8TqOcs75gj/pu1We/QOgC2x/8idtAeUgPoSTEY8uBQXBFxIFtgodtdEP2QNTdYNB4b0EUtRlBAJDEN/J49/IRBBzfWpAEr1tDrlClUJJIutdkh8Lx6/YY8H5cRgNQsJBB6cxkqlD/WYPdUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920114; c=relaxed/simple;
	bh=lW5SvURQ/qqlXR97ajJE1Ms/b3eIrZ/LJJpulaRcSxk=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a5LHsJvl44UwsSOZ0RIDDaVHsa1nxJsFZggsutogaBEuTcPeDcu/aQU2hsdzvI1+dLMigooSYFTqmFbFq3TunWm6tDwAv2RNM5AfE6bYMmITw6rhwIgUNtYz2uZDznRK3D0N9ZJpfgDYvDYjkMGw90XtLWXpM1EhUp65YyAjDX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gYqtt2DQ9zKHMwP
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 19:43:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2C29640590
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 19:44:24 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP1 (Coremail) with SMTP id cCh0CgAXGj8UqyZq6No+BA--.50768S3;
	Mon, 08 Jun 2026 19:44:21 +0800 (CST)
Subject: Re: [PATCH v2 0/4] show orphan file inode detail info
To: Jan Kara <jack@suse.cz>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
 <lweohtnu6fdvhi2fnbo7obo7vtvehsr4m6u4zwgeqx2abhgx3w@dv5e6zapdwlq>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
From: yebin <yebin@huaweicloud.com>
Message-ID: <6A26AB14.8050508@huaweicloud.com>
Date: Mon, 8 Jun 2026 19:44:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <lweohtnu6fdvhi2fnbo7obo7vtvehsr4m6u4zwgeqx2abhgx3w@dv5e6zapdwlq>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAXGj8UqyZq6No+BA--.50768S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw47Cr1rGw1fXF4UKw4xXrb_yoW5tFWUpa
	9xCr15ta4DJasrCrs3Jw4xXFyrtr4fJ3W5Wr1ag34UCrs8AryFgF1xK3yY9a4kGrWxAF4q
	qr4xXr9IgF98ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2026/4/16 1:59, Jan Kara wrote:
> Hello!
>
> On Wed 15-04-26 18:55:01, Ye Bin wrote:
>> From: Ye Bin <yebin10@huawei.com>
>>
>> Diffs v2 vs v1:
>> (1) Fix sashiko review issues:
>> https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com
>> (2) Change "orphan_list" file mode from 0444 to 0400;
>> (3) The display format of the "orphan_list" file is modified according
>>      to Andreas' suggestions.
>> Fault injection tests have been conducted to address the issues raised
>> in the sashik review. There is no UAF issue in the ext4_seq_orphan_release()
>> function. The reason for this has already been explained in the code comments.
>> In addition to the fault injection tests, we also performed a stress test by
>> observing the /proc/fs/ext4/XX/orphan_list and the concurrent processes of
>> adding and removing orphan nodes, and no issues were found so far.
>>
>>
>> In actual production environments, the issue of inconsistency between
>> df and du is frequently encountered. In many cases, the cause of the
>> problem can be identified through the use of lsof. However, when
>> overlayfs is combined with project quota configuration, the issue becomes
>> more complex and troublesome to diagnose. First, to determine the project
>> ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
>> then retrieve file information through `debugfs`. However, the file names
>> cannot always be obtained, and it is often unclear which files they are.
>> To identify which files these are, one would need to use crash for online
>> debugging or use kprobe to gather information incrementally. However, some
>> customers in production environments do not agree to upload any tools, and
>> online debugging might impact the business. There are also scenarios where
>> files are opened in kernel mode, which do not generate file descriptors(fds),
>> making it impossible to identify which files were deleted but still have
>> references through lsof. This patchset adds a procfs interface to query
>> information about orphaned nodes, which can assist in the analysis and
>> localization of such issues.
>
> Ye, did you read my comments to the v1 of the patchset [1]? I didn't see
> any reply from you. I don't think this is a good way how to expose orphan
> information for a filesystem for reasons I've outlined in that email.
>

Hi Jan

I thought about how to prevent resource exhaustion caused by making too many
FDs in a single application. My idea is that IOCTL should only obtain one FD
at a time, and the next time it should start obtaining orphan nodes from the
inode after the previous one. Each time an fd is obtained, the previous fd
should be closed. I expect that after traversing all the fds from the beginning,
they will all be closed and there will be no need for user space to close them
manually. I wonder if this approach is feasible? Or do you have any good
suggestions?

> 								Honza
>
> [1] https://lore.kernel.org/all/n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq/
>
>>
>> Ye Bin (4):
>>    ext4: register 'orphan_list' procfs
>>    ext4: skip cursor node in ext4_orphan_del()
>>    ext4: show inode orphan list detail information
>>    ext4: show orphan file inode detail info
>>
>>   fs/ext4/ext4.h   |   1 +
>>   fs/ext4/orphan.c | 326 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ext4/sysfs.c  |   2 +
>>   3 files changed, 328 insertions(+), 1 deletion(-)
>>
>> --
>> 2.34.1
>>

