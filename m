Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81D386450
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2026 18:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776709736; cv=none; b=Szhl5KJyQ1uiCC+g+RwPIPoB/gUDXiZcoxwMRjlTKmeYl9UPpzSN3i9PD89xE9bJKHDCjmO5rNpzM+gOb9Ah/77dnjXt+jRTXHt/3/Bnv0BT537741YWJ551yqdQylg3NedSDJAP1zGMfTGwNkNP4gBQjeq8n9WNxyDvzuEGxK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776709736; c=relaxed/simple;
	bh=LJKHwJcegUB/jQVQn10iVvMk7S1HdyFsGUQn5BMofO8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=a0QPx3fQT8P3nteFMH22xVltS9m4H36HviXmhTpZDIEZgHcuSqWgXkwaUODIcDv1A4dO5dof7htfXfajs+onPutyYDuK466QWhTsNp90H8T7uvbD5oRsEptn+ugYVvMWxj3YkxI+wyRC6PeNHjHD/TPl6WxJwnWV6tg9wEQuyDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=KGy2bfeo; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="KGy2bfeo"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so1993978a91.3
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2026 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776709734; x=1777314534; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxmf+ZnydhfcAuCN/18cB18mIpsDQYQPLCNSAmWIEeY=;
        b=KGy2bfeoARLrSBj3ngsx9NUdEWPAMXn261bRQOlBr4SbVtRiDxxUXer2wRXdm8toim
         IwnZL+LhcKhwljZoeIxnDNyd7K50o3ch3sUom/QT9QgiJKRamoO13t0sSrYkbW1McB3V
         4S99h9EnJyqWP0MZw6p1K1dkHtn8VHIF0+tgCWiJNImBSfwavecB8GfgOLbVoBnUC1iN
         f2WRCUg9IvW2gAI5T1rUCnLxbI3NAacv3axVzB5cOIWTfOXnl7e0wstkIJlmvrce5w72
         QKV4FergkpCDZHKUTijfMt8h7fkeMmk7giBFGp1uu2o8qc//e2ks3AHzVgUL7aN+KcAV
         oKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776709734; x=1777314534;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uxmf+ZnydhfcAuCN/18cB18mIpsDQYQPLCNSAmWIEeY=;
        b=shFGyLrWU/jBD6Qdv2W4TEsjLIAEp/o9TsauCa8bu1WJgWsJTHBNdy15XByYZDcVJS
         grgq0j75YRoCnrc4DqBdjWVVk6HA+ltRHKCJtyTTCCsngr4HIbPPOm3eWJIVE7Ra4enl
         eFaOa4GNLtATHFuAk0yjNddcdWnWVlKeFSXD7juqSruAUx/D6puoqof/qXb3S4mMN5ZK
         kkpfbOIB0GLGTL9I+ta0pFif/uTlhHChlrnsEz9CQgGlUu72m01mBn6s6H4J7qJTXnTW
         5GvXV5JrwWRDUiSVLOgblVcnF6gHFgBrW3k8RosJpEQfBF5T+UBIUzmczV30WcnjcX1n
         TjTQ==
X-Forwarded-Encrypted: i=1; AFNElJ/wdErqJdG8w9ApBpFq2ljXUCOJATUa4lXZNtmtZfDR450aW2UaMVmkuTuRpI0CPGXQ9rOpXPuRB1zI@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4LtC1iFe+QEmiCdeTlRi/NqgsSecv+gQIfI1SKVkXsRDPolPQ
	YKdoTqDiVscjCGzqaQD2w9fGgnSiErII88/1puJ3wao+aq9Ddw2qATka1XrArdWkEcSRNqdqgKn
	fa9kA+Js=
X-Gm-Gg: AeBDietHP1sy77zdQeVcog/KZaYZpBqfKuRXRbxEkjTFDVqZlBsBeR/D1tA4XauBcbY
	IpI46H0b9fHUI9cBQ9uLL/adPAFBnE4u5Acvv0WiI6WdUNvyk1F4e3CClYVC/35mtfDIgDuk0aW
	droXhoLM6BmUZ7LGDbkXlCaqlEIQx69Al+f7GLcEEEJxtOEiD6pwCbeej+cWbQcA3sLRmWGnwr+
	clo+w7K6cNifAsDkZ17dArQteQ2EtKDZ1iYXSIuc8ocsH6j3y1SYktuY3ZAGgEJwzADmBrJh4nM
	FbZFb1sUK355Ac+I6GjQoGgLxSMI+O6X5cJSSZZ+9Iu6+8K0V2OHv+g1switSQBudjf8TP872Mc
	ouS6pb6uAVoAd+IwWLETkMmZfMxTAV/MP7H6Dazyu1gnQpguMdr0G+fhwzU43vaJ0lZtihhutKh
	yY8/9znQRViS7H3X52nBdh5O+GXXgZw3guDC9UqpYZ14aJ5vKbTqcBrs7yr8TR7KgdxDbXg5CaT
	lMMTEKDxs+Lln9QPXFolVqV7Wev
X-Received: by 2002:a17:90b:1dc6:b0:35b:e51b:1935 with SMTP id 98e67ed59e1d1-36140462ab5mr13504729a91.17.1776709733850;
        Mon, 20 Apr 2026 11:28:53 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614198f775sm12938037a91.16.2026.04.20.11.28.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2026 11:28:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Date: Mon, 20 Apr 2026 12:28:41 -0600
Cc: Baolin Liu <liubaolin12138@163.com>,
 tytso@mit.edu,
 wangguanyu@vivo.com,
 yi.zhang@huaweicloud.com,
 ritesh.list@gmail.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <4A904858-8611-42BC-B1BD-9679F284F8EE@dilger.ca>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
 <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 20, 2026, at 03:12, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
> 
> On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
>> From: Baolin Liu <liubaolin@kylinos.cn>
>> 
>> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
>> mballoc statistics when 0 is written.
>> 
>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
>> ---
> Hi Baolin, thanks for the changes.
> 
> Seems like userspace doesn't have any way to know that writing 0 will
> clear the that. Well, I guess if you are looking at this file you are
> anyways debugging kernel code so that should be fine

That could be documented in Documentation/filesystems/ext4/allocators.rst,
or better would be to add a new file that covers mballoc in more detail.

Cheers, Andreas





