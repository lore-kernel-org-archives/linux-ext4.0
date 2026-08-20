Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65173E5EFB
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 09:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218298; cv=none; b=dCt4fnyecc7R3/XJnblh+s72pzlJZ/P8qm+Dd0la+8hGaZ5Od07GGLmmyRgph/ERuvkKRLmtpOy7LDl/AK4MbPyVLJBOgF1y7hQsgbMzPuh369WN2TlzTXuqdki+YxhUaXcyDnZUsDlM/4yiz7p+AhJSikd78FVaK9j9b/khoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218298; c=relaxed/simple;
	bh=X91BR6hnRFqJLfNJe8kieezAl5qpauGkI5pHrzRWeXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1GOlvkhfCQgzSX0/MavkbUyXDEpXGYNGQERaqY9nmaNGb6rbcHu3NrkPZQuEUpC+eWfTSgIjAgESHQVBt88iCcoU/DmmkLpXjkwJGerKI7ZLRJH0e6qYZbdQHXwJrwHa1pnmmSxkZGtaFyl8l+q4bWrGhtggGznmA6WYz3hwIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JPo6oMJq; arc=none smtp.client-ip=91.218.175.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JPo6oMJq"
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=X91BR6hnRFqJLfNJe8kieezAl5qpauGkI5pHrzRWeXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787218293; v=1; x=1787823093;
 b=JPo6oMJq+oqX1uGCR8UlXUmIQJfuxGVldEWv+0WHFT3PV0gLUi81AwNc1zc0R2i+MGoBcqkL
 qyPr3ms7vw10JjjUuwxNouP8jcca9uqvgTU0bSZnRqhPbWm84hPit0lZg8qoW+gwVEoRnw5J8Fa
 0jxhDaulydVyquVsNxANFWqo=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: from [192.168.8.135] (87.104.0.147)
	by smtp.migadu.com with ESMTPS id 06cbd8b77fd6dc5e;
	Thu, 20 Aug 2026 09:31:23 +0000
X-Mizu-Trace-ID: 06cbd8b77fd6dc5e
X-Migadu-Flow: FLOW_OUT
Message-ID: <47034326-da2d-4eb4-b6e7-a0d16972b1f6@linux.dev>
Date: Thu, 20 Aug 2026 11:31:18 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Alejandro Colomar <alx@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, hch@lst.de, Zhang Yi
 <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
 "Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
References: <20260820090400.857720-1-p.raghav@samsung.com>
 <aobIkmL6d9x5nPPg@devuan>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aobIkmL6d9x5nPPg@devuan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 11:28, Alejandro Colomar wrote:
> Hi Pankaj,
> 
>> Date: 2026-08-20 11:04:00+0200
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> This flag was added to the kernel in v6.17. As of now, only ext4 and
>> block device nodes support this flag.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>> Changes since v1:
>> - Change the phrasing around zeroing and its condition (Zhang Yi)
>> - Update ext4 support only for extent-based files (Zhang Yi)
>>
>> Note:
>> This feature was recently added to XFS and it is expected to land in
>> v7.13. I will update this man page again once v7.13 is released.
> 
> Do you really mean Linux v7.13?
> 
> 

Oops. I mean v7.3 :)

--
Pankaj
