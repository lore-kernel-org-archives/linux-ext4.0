Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884BE3E7BCD
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781178196; cv=none; b=j95Yjw2kD2B6cq4Y1qSkPj7zW9WNwzNl89Kor19Tu9nXPpo3BBQNwI/dITTEtb0OJJCWXtoNmhR2UAqS4ry+DAFADDUqsOanrGTvlCzmwZh/Y09ZqTbu5LbgKQ4JHpJsTwUmkh8UsKbZxk5Ou0dXFeleubv+RozYt73ojaWzIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781178196; c=relaxed/simple;
	bh=rPiYnZCoMo+4r1uoyQpZsPfds62Fg4F7Xo8U9CMYfBw=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lMKm90+9XAmxpGgrTorqy8U8/Rtfy9i9fpNekyKJW1JdkYOzFKiU4i0S3Sd83HwERS1OO3vS8lZUzusd7jIEewzGP5Ls55lnsw/7DHVHiU77D7QSlreFRGr724/hWNK9UhF0T6kS1StrmBB/vn8XpCkOgoz10AHqE9ujET6ZU9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gbgjr5fw4zKHLxN
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 19:42:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7195040539
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 19:43:03 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP1 (Coremail) with SMTP id cCh0CgAndzxCnypqu5WnBQ--.14056S3;
	Thu, 11 Jun 2026 19:43:00 +0800 (CST)
Subject: Re: [PATCH v2 0/4] show orphan file inode detail info
To: Jan Kara <jack@suse.cz>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
 <lweohtnu6fdvhi2fnbo7obo7vtvehsr4m6u4zwgeqx2abhgx3w@dv5e6zapdwlq>
 <6A26AB14.8050508@huaweicloud.com>
 <a5v57ie6feotxznmhrf3i22gzplw2ucotlnw3y7hmjhkalbb26@bx2lzoil75ks>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
From: yebin <yebin@huaweicloud.com>
Message-ID: <6A2A9F42.7070702@huaweicloud.com>
Date: Thu, 11 Jun 2026 19:42:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a5v57ie6feotxznmhrf3i22gzplw2ucotlnw3y7hmjhkalbb26@bx2lzoil75ks>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAndzxCnypqu5WnBQ--.14056S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF47Zw1Dur1DAw1ktrWxCrg_yoWrAw4rpa
	y5Ca1YqFWDJFn5Gr4vy3W8XFWxtr4fGa1UWr1Yg343Can0vrySgF1xK3yj9a4kGrWxAr4q
	vr4jq3sIvr98ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



On 2026/6/9 19:13, Jan Kara wrote:
> On Mon 08-06-26 19:44:20, yebin wrote:
>> On 2026/4/16 1:59, Jan Kara wrote:
>>> On Wed 15-04-26 18:55:01, Ye Bin wrote:
>>>> From: Ye Bin <yebin10@huawei.com>
>>>>
>>>> Diffs v2 vs v1:
>>>> (1) Fix sashiko review issues:
>>>> https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com
>>>> (2) Change "orphan_list" file mode from 0444 to 0400;
>>>> (3) The display format of the "orphan_list" file is modified according
>>>>       to Andreas' suggestions.
>>>> Fault injection tests have been conducted to address the issues raised
>>>> in the sashik review. There is no UAF issue in the ext4_seq_orphan_release()
>>>> function. The reason for this has already been explained in the code comments.
>>>> In addition to the fault injection tests, we also performed a stress test by
>>>> observing the /proc/fs/ext4/XX/orphan_list and the concurrent processes of
>>>> adding and removing orphan nodes, and no issues were found so far.
>>>>
>>>>
>>>> In actual production environments, the issue of inconsistency between
>>>> df and du is frequently encountered. In many cases, the cause of the
>>>> problem can be identified through the use of lsof. However, when
>>>> overlayfs is combined with project quota configuration, the issue becomes
>>>> more complex and troublesome to diagnose. First, to determine the project
>>>> ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
>>>> then retrieve file information through `debugfs`. However, the file names
>>>> cannot always be obtained, and it is often unclear which files they are.
>>>> To identify which files these are, one would need to use crash for online
>>>> debugging or use kprobe to gather information incrementally. However, some
>>>> customers in production environments do not agree to upload any tools, and
>>>> online debugging might impact the business. There are also scenarios where
>>>> files are opened in kernel mode, which do not generate file descriptors(fds),
>>>> making it impossible to identify which files were deleted but still have
>>>> references through lsof. This patchset adds a procfs interface to query
>>>> information about orphaned nodes, which can assist in the analysis and
>>>> localization of such issues.
>>>
>>> Ye, did you read my comments to the v1 of the patchset [1]? I didn't see
>>> any reply from you. I don't think this is a good way how to expose orphan
>>> information for a filesystem for reasons I've outlined in that email.
>>>
>>
>> Hi Jan
>>
>> I thought about how to prevent resource exhaustion caused by making too many
>> FDs in a single application. My idea is that IOCTL should only obtain one FD
>> at a time, and the next time it should start obtaining orphan nodes from the
>> inode after the previous one. Each time an fd is obtained, the previous fd
>> should be closed. I expect that after traversing all the fds from the beginning,
>> they will all be closed and there will be no need for user space to close them
>> manually. I wonder if this approach is feasible? Or do you have any good
>> suggestions?
>
> Hum, I think you've misunderstood my suggestion in [1]. What I suggested
> is:
>
> 1) Provide ioctl GET_ORPHAN_FILES that will return one "virtual" fd that
> tracks state of iteration over orphan entries of a superblock
>
> 2) Reading from this fd will be returning file *handles* (as struct
> file_handle) describing the orphan inodes. There are no kernel resources
> struct file_handle occupies in the kernel. It is essentially just a
> filesystem agnostic container for inode number and inode generation number.
> Userspace can then use open_by_handle() syscall to convert struct
> file_handle into normal file descriptor but that is upto userspace and what
> it wants orphan information for.
>
> Is the design clearer now?
>
Thank you for your patient explanation. I have implemented it according to
your suggestion and am currently testing it locally. After the testing is
complete, I will release it. I hope I have not misunderstood your meaning
this time.
> 								Honza
>
> [1] https://lore.kernel.org/all/n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq/
>

