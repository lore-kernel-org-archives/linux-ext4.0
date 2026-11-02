Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620260;
	b=gbSAT5CVWWqCSGlkrqcORhbujRjtPyODZfA+Mt39r3I/XtSmm3QWQ6K/4DG4mPmwrrUf
	 r15f0MVS0B+0+ydYQxlWk6QK8WYUKc0bPufEN2hKF8p63QoawXP4pG1A9EMTDIEKGrKsl
	 FZV0OrGIf/tgsHN+oOQF/2q2XhLM9vOE/p4tJSMAnMVe3JC61BU3nqKMEyxN0nG/GAQwG
	 4gL04+KBSvRe5X3KU1980qdmnCWZ2mxWfY5ddEr4ss9Ss1H9uHEdKRZiaDSB+c2R5XljN
	 +CtA5Fz8hMrPOwHuG8x2phyOwnzDZkqK/3GRlC3sFMNT5rRlhWQMRL8EJHJYXUv1rbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620260;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=yBfXxrtyA/u/OWX/eqMUUK3wKj96MZ0bPzQISUlZz2g=;
	b=C8li4QvtbKM/4i2rt56TU4ACV1LGSXp62jmImBSCO/uFZBoreLSBM785LN+mGeXVRSap
	 m6XrltQFqdL4vE8VsKNmZjI1nbGZ0r0ypkjCztdWijuzTosHU5ZUjtUijdQqhwOOw1yOO
	 ztgHizgJL6wEIsE6CSkIZ6zGVHS4bRULattU4MJ2xZg+8CswhiIknEA4h6wIc1xW32vSX
	 sC5PpV4wY0G3GgEKt7aBf/6Kv5YRhXzFD1bXiSXsVelHKH0oFdSF4rRmbv1XYdCwc3K94
	 3ubA4+pStTzTLl8PhCVQ550dGlaCQduBAVdq/mjL5+eoV++C+dC4c6mtdfO8m+mm0Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF45606A324;
	Mon,  2 Nov 2026 11:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BF45606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jJ94j4Qh1z1rqfJ;
	Mon,  2 Nov 2026 19:50:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 159914056D;
	Mon,  2 Nov 2026 19:50:53 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfQbeehq7KkwCw--.20107S3;
	Mon, 02 Nov 2026 19:50:52 +0800 (CST)
Message-ID: <a77a4e79-582a-46fe-a01e-070db9fa43ca@huaweicloud.com>
Date: Mon, 2 Nov 2026 19:50:51 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: report unwritten extent conversion failures as
 writeback errors
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
 <20261101102145.647496-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261101102145.647496-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3tfQbeehq7KkwCw--.20107S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1DCw47XF47Zw48ur18uFg_yoW8Ar1UpF
	WDG34qgFWv9a4fCFs5GFW7Ja4vqa4xKr47ury7KFsF934DXFnYyry8KF1IgF1UC3y7Ja1x
	ZFWFkFykXwsrJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/1/2026 6:21 PM, guolingxing wrote:
> When a data writeback bio completes successfully but the subsequent
> unwritten extent conversion fails, ext4_end_io_end() does not record
> the error in the inode's mapping writeback error state.
> 
> Bio failures are already recorded by ext4_end_bio(), but conversion
> failures are not. When the conversion is processed asynchronously,
> its return value is not propagated to userspace, so fsync() may
> return success despite the failed conversion.
> 
> Record conversion errors with mapping_set_error() before
> ext4_release_io_end() ends folio writeback and wakes waiters. This
> allows fsync() to observe the failure.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you for the fix. This looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Changes since v1:
> - Drop the incorrect Fixes tag. The conversion error was already lost
>   before commit b82e384c7bb9, as pointed out by Jan Kara.
> - Collect Reviewed-by from Jan Kara.
> 
>  fs/ext4/page-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 734d856a6d478..2701452fa65ca 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -192,6 +192,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>  			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
>  	} else {
>  		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
> +		if (ret < 0)
> +			mapping_set_error(inode->i_mapping, ret);
>  	}
>  	if (ret < 0 && !ext4_emergency_state(sb) &&
>  	    io_end->flag & EXT4_IO_END_UNWRITTEN) {

