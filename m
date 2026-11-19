Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099695;
	b=Oz7fK69HONQqvuyjfI+ncva4fTcv056pNwtoIuq2eM8IEQSXadw0HrDrUsabefiL360c
	 O8pXovh31GHKDp8VxRerNtJekkI44YQItgd5sEbKKV6ccrcaglj2GjKyiycbKm48FhK/S
	 9rU35gLnMes/r/JYyrlvsQBiEhKg3HQVztkQw3uP2MIhHlU4apFeEg+LI4Amr3MiKHw3X
	 hV8bfKUmTM9t4vHyYuSoVpd7W3yxpL1yhshXLhQLcxXQI+PBfFSarGnFGO88MEhVv0XHc
	 7EGAN5LTZrq8SKm8a3XXWzfk8vG1YzOjesfS7yMm1zanSN2HCWcM4X96QqI3v5IAX1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=pm9lVMfj6HY9667X9jxurY0vz6VfQGJmnrSjwdBOSf4=;
	b=tx0mRA6qOChtneVOK1I9vDiGBXGb9Uij//0dnUnSKcga0GDtcmXld1F8aqAWv2X+yrCg
	 ABUd0mvySzyLlaAr4uCFUtyMO81KHs6r8oh/s5YcKW15+CRPzM5ZeZPTQmxXfQI/F71h6
	 BCce4K61FlBjtQyTFvCw/CmU/SwACyeNLfRtVxZWZ0vAcaoSfTejaif/VD1cHZE6r0gVA
	 bsdol/g1J0IuqjJVdV1Cbj/GZk2RjSwUwN+th2hK6FB4m+JPXHy3rXRwPIXHcXSE9vJuh
	 tAu8kiJ3+CcLM7RJ/94WhWAnAcUUhClDBAr4JYbvlnEShbfy7ZabqzMq03d2CtyIQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XReAmhmY;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84A7606C316
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C84A7606C316
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XReAmhmY
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElWqb017775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099656; bh=pm9lVMfj6HY9667X9jxurY0vz6VfQGJmnrSjwdBOSf4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XReAmhmYLOSJO6Ok2GTj55dI2Z2dCdC7MzSfvOCFrtM+LpAwzLBPUq6/IbkjHArbV
	 CR4amkRhup8S2dL8twuLwUB+Jb8YqbRZmbnZD9DkoIDlwAhO5fCUMC+QQI/eU/SLpd
	 mg1L6HRTOR2J4w4v8kIWE2WgpQW/uECzPDY/LJ+OoUC4cNOleCYa/IP8qPuf/RLYjH
	 E5TkCYoPPFPm2CpELX2jlXxVKP2ErLknqixtGHK/jgeFiLshOat4El4kC5YlSN2VeR
	 EoQO8voHurTnpCPmckRMHMDQAgK2PsGRPlwTmpml3w7KVn7A5Qere8B7hHDCCDuf4y
	 atE3ifLu6o3Bw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id ADF742E00BB; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        shuo chen <1289151713@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH] ext4:Update the pre-check in ext4_find_inline_data_nolock
Date: Thu, 19 Nov 2026 09:46:30 -0500
Message-ID: <179509948666.1938961.16930975533553139254.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
References: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 10 Sep 2026 11:26:14 +0800, shuo chen wrote:
> The pre-check in ext4_find_inline_data_nolock should be kept
> consistent with that in ext4_xattr_ibody_find,so as to avoid
> unnecessary operations.

Applied, thanks!

[1/1] ext4:Update the pre-check in ext4_find_inline_data_nolock
      commit: 1f4899b2b822ece9204517be61855a203cdd59b5

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
