Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1185036606B;
	Fri, 29 May 2026 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780068853; cv=none; b=HPfpwLsqJ1NQbRI2/bvkxL5SRRddDkJv35KXLkj4k6oYrKgHsY4JUk/gaUyyKNWHMsZv2NJalHzxT52b9kLBr03i06C6uugiL22LisA7GetiYArwGLQ5egiLk7CwalHIIYs5c7B0TjDc+yqqw1sveMH0Iqs0un2BamNatkJovlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780068853; c=relaxed/simple;
	bh=F1lbZw4LAjjbIa/aHPKXCdbGtCnX0Z4YMLxw8SQjtaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjrJb5Dk0uz/akoP6W+yuUnJ8FaoZeWGnZ64ohVh/1mBIunhMrexL4ElRFTYV5AmvGuK1UUImaBQkZMwP9x6mteHFmnMKZV/L+zMAT1Brmzz4L0RFIZupEAT3lps+zDOpGWAvKKSPaGrprwNZxY977QswZLhrieb6ZXaEvQfelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.224.235])
	by frasgout13.his.huawei.com (SkyGuard) with ESMTPS id 4gRnMC2kzvzpSvj;
	Fri, 29 May 2026 23:28:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.47])
	by mail.maildlp.com (Postfix) with ESMTP id 6E6D94056C;
	Fri, 29 May 2026 23:34:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.224.106.87])
	by APP1 (Coremail) with SMTP id LxC2BwC3Z6HgsRlqQNENAg--.11485S2;
	Fri, 29 May 2026 16:34:01 +0100 (CET)
From: Bohdan Trach <bohdan.trach@huaweicloud.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Bohdan Trach <bohdan.trach@huaweicloud.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lilith.oberhauser@huawei.com,
	bohdan.trach@huawei.com,
	mchehab+huawei@kernel.org
Subject: Re: Re: [PATCH v2 1/2] ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
Date: Fri, 29 May 2026 17:33:23 +0200
Message-ID: <20260529153330.18942-1-bohdan.trach@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <560F1E7C-47C0-41D4-856A-ECB9BE4BDC3E@dilger.ca>
References: <560F1E7C-47C0-41D4-856A-ECB9BE4BDC3E@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:LxC2BwC3Z6HgsRlqQNENAg--.11485S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4DZry3tw4xGrW5ZFy3twb_yoWrWF18pF
	WSyr9xKF1DJrsruws7tws29r1jyr1ft3W5XF98C348Aws8Cryagr1IgrW0vF9rGrZ3Z34j
	yrW0k34UuFyDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: xerkvtvqow2ttfk6x35dzhxuhorxvhhfrp/

On Wed, 27 May 2026 19:46:43, Andreas Dilger wrote:
> Thanks for the patch.  Definitely the benchmarks in the 0/2 email show
> significant gains for the Kunpeng system, and reducing contention makes sense
> as core counts increase and the likely case is that the bit is already set.
> 
> That said, I wonder if this should (also/instead) be put into
> test_and_set_bit() itself, or add test_and_unlikely_set_bit() or
> test_and_rarely_set_bit() (or similar) optimized for the case where the bit is
> likely to already be set.

Thank you for the review. I understand this concern; I have looked for other
parts of the kernel code to see if this change can be generalized, in which case
introducing a new test_and_set_unlikely_bit()/test_test_and_set_bit() would have
been a more appropriate approach indeed. Alas, I could not find more of such
cases, and thus I decided to limit the change to the ext4 code. Maybe developers
with more knowledge of their subsystems know other potential use cases for such
functions.

> I see in your benchmarking that there is not "apples-to-apples" comparisons
> for ARM(Kunpeng) vs. AMD on the same storage.  The storage hardware and space
> usage is different for each test run, and the ARM numbers show only marginal
> gains and more negative than positive results at all thread counts:
> 
> > Benchmark on an existing file system for AMD 9654 (15T FS, 6% space
> > used), kernel 7.1-rc3. This shows the performance impact on a mostly
> > free file system.
> > | thr. |  base | patched |    improv. |
> > |      |  perf |    perf |            |
> > |------|-------|---------|------------|
> > |    1 | 30901 |   31191 | +0.9384810 |
> > |    2 | 50874 |   50504 | -0.7272870 |
> > |    4 | 66068 |   64108 | -2.9666404 |
> > |    8 | 63963 |   61927 | -3.1830902 |
> > |   16 | 47809 |   47044 | -1.6001171 |
> > |   32 | 42441 |   42326 | -0.2709644 |
> > |   64 | 39773 |   39929 | +0.3922259 |
> > |  128 | 37065 |   36413 | -1.7590719 |
> 
> 
> The performance reduction might be caused by the now double memory access on
> AMD that is only adding overhead on that CPU implementation?  It would be useful
> to see the testing on Kunpeng vs. AMD/Intel on the same storage device/usage.

I've looked a bit deeper into these results (which are different from the 133G
FS image results on AMD). The flame graph is dominated by contention between
open and unlink, e.g.:
    ... -> __x64_sys_openat -> .. -> path_openat -> down_write ->
    -> rwsem_down_write_slowpath -> osq_lock
against
    ... -> __x64_sys_unlink -> filename_unlinkat -> down_write ->
    -> rwsem_down_write_slowpath -> osq_lock
and ext4_mb_prefetch does not feature anywhere in the flame graph. So I think
in this FS configuration, different code path got stressed, the numbers should
be ~0-centered noise? I have definitely seen a correlation with the space usage
percentage of the file system -- on a completely free file system this patch
does not help much irrespective of the architecture, though I did not pinpoint
the root cause for triggering the linear group scan to the usage% specifically,
or if other factors can influence it as well (fragmentation, etc.)

OTOH, the storage device should not matter much for this (admittedly very
limited) kind of benchmark, as the main case where this optimization matters is
if there is a long iteration over groups, which makes ext4_mb_prefetch()
CPU-bound, and this does seem to happen more often as the FS becomes more full.
This was actually the intention of the test with 133G FS image (below the "big"
FS results in the email) -- it should fix parameters other than the underlying
storage device (which should not matter for this test). 

> That would tell us if it is more appropriate to optimize this in the aarch64
> test_and_set_bit() rather than in ext4.

I do not believe this change can happen generically in aarch64
test_and_set_bit(), as in a situation where the bit is flipped frequently, this
change will most likely hurt the performance. This probably depends more on the
CPU microarchitecture/cache coherence implementation in hardware.

--
With best regards,
Bohdan Trach

