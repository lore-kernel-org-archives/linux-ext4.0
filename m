Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD94400990
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 08:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786435792; cv=none; b=TZzKkPQm/gXGvepMe4dkvFhiv2LbTS4nulIjVzuBnzrE60mtfIO8g9fFkadJTfUFaOaGQlBXFrFPHwADjxXGEq7gwSfT+jj/k6kyWTMReLOTpLOit5Ri0zLNeMi+feN0v8x7IB7SY+medPmR8lapRgVICiChE/kC9JhjvfD6iZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786435792; c=relaxed/simple;
	bh=yh28wnOYtBhyHwBSkkm3wZY/Vkiz10BNYcYlU/BmhLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvK96v87M5EV3nlhyTgIXBYk8qtEm+W9liupxY3tGgIpiFrO43nT5281CLm5cZ38IDdL/d3n1VLh3GWh66L/kwZvh2Et67BRRpcpy4FQx0UvtOZyxlhs1qSpp4TFIjiICqQRJ57Nm01j/K41WyZkpb1+Aeo3W0J7md1T0fmu/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=naFdHkE9; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="naFdHkE9"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c998fd549a8so2087460a12.2
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 01:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786435790; x=1787040590; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yh28wnOYtBhyHwBSkkm3wZY/Vkiz10BNYcYlU/BmhLI=;
        b=naFdHkE99xSKdcj62yFnEMPJ0Yl3PtTQaGXEVhgXebmopKs6fuLqeNvv36YHK/LGhG
         tk9Ldllc6SGG4aVXhMuYrq8I41jxYzr8r3Rb7QxdKPsJVgswacO33sQb50zxFShVc467
         QhI4UtGq0OHTlpqUZtCvvw4WLi5EyKu0rYPyw1mNHN5NWLbC+vDDW4JucceAhyacHEed
         RqTdaPH5iJ+GJWMV4yz4vp3RpXHr2YmgafDDyw9fLhiQ6tgum8/IHq3vSoBalwMTKVpE
         wAirKa04FwBZOYnCMekx2wFaqzfoHB8cIcVvSPm3ljPHqkWtJ7eYizMCvUBtFbt/vdCL
         ov6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786435790; x=1787040590;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yh28wnOYtBhyHwBSkkm3wZY/Vkiz10BNYcYlU/BmhLI=;
        b=AcytVcgPbztYbUa24wwsMN2GrcfclnFGrJXoA3lcULiPKMSpCnzh5imQjLmq+BsHl3
         U0SI0UZz2C0fxQQss2Ce8Yp3pPlAWVADJ0+mjt+CHKWN8x8mWDrEO+ekdF6A2Y3cB301
         HXyC3IN+Is5QuahMZLldOVm28gTVxn2+8aBtJMZjX8/E3XsxnKBznBoQiTUPHQdJweBY
         RsXIwiXp4Z8gOLkV8OouznfqxxsZoaANRCtBh41AfsOmhVPTz4z4XJZ1suXhb2qxEFFM
         +jIz3GBn47C6ptEtxYzZLsWZaRyqv7lJfUAElTgZAZSIfH+MlVqe7hMSXRTI+X5fhFRo
         LH0w==
X-Forwarded-Encrypted: i=1; AHgh+RrYYJukcnJWjiue9o9mzywJ68JLtM81ErNzTMQPAsBxe3PwfKrNTacNHhub0CdlUWHE7F70XEIQqtOZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0Wieme5o8pjxYbdLaTsVzyhF5Mw/Sk2muU3f8Mvq/mzoknCwf
	KtWfoSPhsrU3AOwb4AZ3jfKMLitihYky5lxYc/MTWDtESvmHhOy9gLEZ
X-Gm-Gg: AR+sD11gd8f7faeiAVdkGdv95a/NmtEpiKdycAf4QcKLTD64EXd0HrsWnLxbwX8PXcp
	P9fvg4FTozLlEDi0bgAZRWJpPxiv3uI8uV3kT/rMX5g7OoHbm8E7uDOCjSjOIXsRpITS19W4GPI
	0cIIdFmefdxdNXszAxWCGBhhMQSr1ICPDkBNGyNslMozr/wlSATKnd2bpu85fTKLsH5CCz+C6sP
	GoSR67cV/XUYRENJz+N/MdiFk5zDo/NR5ojBLqEPmD1JSdQHC86PiukjqEgbw4JqF1WCQIgsgKJ
	xYi+SNXvnTlhlPFsTOs9FHQs8UGniRlBmNzv7wLB3JFh7HRkh0v/enQbBziVLawPR020QbQmFC6
	3C8yV3Bs4KEBOqR7kS0mOpbj+SCV3snHXF0IRqvsTYZdGByEs/pYR4yA0/DW9MmtGzqPbekCRBD
	m4unc90nEPWvnaAPQtD7QUSIWl9hmS4pQK3t4I/bxUWrrkKOmCznbZ5K2OxFDASiq0FWUsJGMbt
	haqdCmY76FmsWoTw2QwTw==
X-Received: by 2002:a05:6a20:9630:b0:3b2:a809:1000 with SMTP id adf61e73a8af0-3cc2b77c1c6mr2331442637.3.1786435790379;
        Tue, 11 Aug 2026 01:09:50 -0700 (PDT)
Received: from [10.0.103.114] ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed8ea050asm476291a12.29.2026.08.11.01.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 01:09:50 -0700 (PDT)
Message-ID: <a4c4618e-d4d5-4cde-b8b0-eb56fe5583fb@gmail.com>
Date: Tue, 11 Aug 2026 16:09:46 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix reserved group initialization
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811021848.1821435-1-guzebing1612@gmail.com>
 <tsp1jrpj.ritesh.list@gmail.com>
From: guzebing <guzebing1612@gmail.com>
In-Reply-To: <tsp1jrpj.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/11/26 10:50 AM, Ritesh Harjani (IBM) wrote:
> This was posted before [1] and looks it already landed in ext4's dev
> branch [2].

Thanks for pointing this out. I missed the earlier submission and did
not notice that the fix had already been applied to the ext4 dev branch.
Please disregard this patch.

Sorry for the noise.
