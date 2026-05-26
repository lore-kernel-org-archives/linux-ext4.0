Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66DA3CAE66;
	Tue, 26 May 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779789883; cv=none; b=nYKYiD9hVRZ6GoJjs93ftpl51nntx+5S8khEB69eBeiOURrkWMeVaINnnhqMfqKzvi95Ondjqwu70lkvmcipWF92kgE2Q9S8MgFXS9+vnJGRp4cpJd0tX6MEoNXX0IusAe0NyDCc99If4WzPYTA5i9ZiQ7whGXBVQPzvoa4n+wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779789883; c=relaxed/simple;
	bh=f5jBmlwLuuM/+fDJ5sCCyDJMX689mLnVFQCMXhaYoDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GExqs/JDhqPLS2feoOxWX8bYbLKw5Svuuag6g6WmXgzCYWxHpMqQM1UYGUIk51OfLxiY6GH3PUDSbhz9JmBtax1oY51Czpxc/FqO4/MekSHzGctZznq5AkpPB+nVixq+aRwBdA+ai8PKgUjYtQg5D4OVWipdFJKTAe/743sMfcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.224.235])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gPpBn0VftzxRS9;
	Tue, 26 May 2026 17:59:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.47])
	by mail.maildlp.com (Postfix) with ESMTP id 2930840572;
	Tue, 26 May 2026 18:04:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.224.106.87])
	by APP1 (Coremail) with SMTP id LxC2BwBHrKUjcBVqcT7cAQ--.8698S2;
	Tue, 26 May 2026 11:04:31 +0100 (CET)
From: Bohdan Trach <bohdan.trach@huaweicloud.com>
To: Jan Kara <jack@suse.cz>
Cc: Bohdan Trach <bohdan.trach@huaweicloud.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lilith.oberhauser@huawei.com,
	bohdan.trach@huawei.com,
	mchehab+huawei@kernel.org
Subject: Re: Re: [PATCH 1/2] ext4: avoid RWM atomic in EXT4_MB_GRP_TEST_AND_SET_READ
Date: Tue, 26 May 2026 12:02:23 +0200
Message-ID: <20260526100232.1057572-1-bohdan.trach@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <wjkbwkkxz5ol3h5zo6npd7lrnzpvesox7cubor6t6gpx4hrdxa@utrefuc6apug>
References: <wjkbwkkxz5ol3h5zo6npd7lrnzpvesox7cubor6t6gpx4hrdxa@utrefuc6apug>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:LxC2BwBHrKUjcBVqcT7cAQ--.8698S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XrWDKFyUAr4kWw4kKryxuFg_yoW3KFg_WF
	1rJryDta4xZFWfJanYgF43Ar1YkrsrK34kXr1vgry5Ary8JF98Gr48ua4Iy3Z2g395K34S
	gF9aqr4293W5ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: xerkvtvqow2ttfk6x35dzhxuhorxvhhfrp/

On Mon, 25 May 2026 17:28:45, Jan Kara wrote:
> Good idea but do we really need the 'acquire' barrier here? I don't see
> anything that would really need this so I think
> EXT4_MB_GRP_TEST_AND_SET_READ() can be just:
> 
> test_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state) || \
>   test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state)
> 
> or am I missing something?

Thanks for the review. Indeed, it should not be mandatory to use
test_bit_acquire(), I've used it to keep the original ordering
semantics of test_and_set_bit(), as I understood it from [1],
and thus of the whole macro.

I'll use plain test_bit() in the v2 series (+taking into account your
comment for the patch 2/2, and retest).

[1] https://docs.kernel.org/core-api/wrappers/atomic_bitops.html

--
With best regards,
Bohdan Trach

