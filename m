Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E45C3E3173
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779698163; cv=none; b=l5o2OEY+AhmzqC2oZQ0jJa7bByx84i2E+3EkDwMzAPBt30NH8ka2y8dIoU4pmlB4mU8vPGKDw3L1C78WQ/7rslVl6zTJBx/LLxgG0JudEUwmaf5p/Z38taBdh0M9lnDTw1ZN9EnvohepNVpPnRdOKNpPgz7rPG2E6jx3XPNLe6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779698163; c=relaxed/simple;
	bh=SzJYw18c8BFlSFH74k1KqMsOQhyX6MjkoMGycJDbafw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIEfwIyV6Crj77gO1z1SgkOZY5MWDaUL/tbghyYYQKgMvAHImv3MBGaGRsDUZLj4KQui1bVwQ+q/wnBWC6X9sA5IihxU29FjVv002EHVZqMqtohU9l7g0WsMv4Ls0/LNj/W9eJ1y2KkzNBvH2VpQdDrYMTa9NVGb1VL0gs6j3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fc4hHQBg; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fc4hHQBg"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bcd3ac3307so55134775ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779698161; x=1780302961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BntzIZqQfdxwPhWe8imRD5hr3gowJvdxsKaf3qs8y5Q=;
        b=Fc4hHQBg3vQt7GCA/rr5d/bwuyuv2nOr10SamRzripUmTPg2/abdoFZtOQxeKPoV2K
         ZlUytxNVjrhTBR+Bu7Q3oaAJLqDXdpgcKayc/6mKSCbFIIr19j3bsusZPN5a51xOZfix
         1Ci+qxQAgf7526AW7Kp8HHguTDYW2zMlgr5wBZ6P+h/XoG2ddX11LSLBHyVQtv5uvTxt
         O4pDWDMTiiTVdR2KzVu61mz08we1yuS0uuuYG7uZTqWKSRHcXtVirXKFvYM6uh0zx/VT
         bswxUsMYSoI0iscKBnbmPhtVF+O9Kwea1f4Dqgcsfu/83+yBA8wUD67ZNoircNcd7mu2
         H6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698161; x=1780302961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BntzIZqQfdxwPhWe8imRD5hr3gowJvdxsKaf3qs8y5Q=;
        b=a925UxjVnt8k8+VCthpuEY3O3gNPYNp97u9S6UnDktr8ULJX76iVlOqJkvVoF1DFw4
         CYiDvywkrLkIznVBsht9PjFwc7dtum32umMETgO0T/Za2RH4k5+7wEmfoB51RmanJ/GK
         HDkKDTyGT5ewuKz96AsJu2B1s908GCVkWjljrzIj4RuW6Q4fJp19C6x5C0OwYx3UBY/3
         4cV91ZyYUSpASKGB5fN8ihrHgrkOw9rhAROQx+u0c3kXI7Rmw9vvaoANLyI9qsTEDFEG
         3uRE37btQvtJmuvc8kfQTvjImo+3HZ5urIybUF4U2xOaqRqLfoL5tFpnF6GAK3mCQW1q
         dMGA==
X-Forwarded-Encrypted: i=1; AFNElJ8254jf3OdixxaFm2XZjEim+83OgHge/2gsq6Hlpclk5YlCUjvipl/TMbdXunZa/akbMtOwLxgficdY@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6yFbeFg2/pnTMcLw9bpFJjPp8YArQa1oI8JcfvO/Q3SSkZNCh
	tg1qKvVpaSsgedh9kBgvZX+5fBHjUZcuIGFQN1AHigwexaRZwCb4Opem
X-Gm-Gg: Acq92OHWD8NTaFP2araE3Fy5j3JencUp4f/Q2pWxjBMNtBgrSGaicCN8ihiMBaBZe3F
	h3Oa1Q33tIArc49kJ/10JVmsoKMc9ME6avIraadxOW2GpLxAhsSSAHYuhvMHZrXLBF7/iTf1MFw
	5azPN2noKgmDikennzFrgUlWC97e2bed1DVIHeSLbO1muG2KOF3AH6miCfc43b8SnD3eBmirHrR
	60w2rWJgMlK95IdjEVW3gUJjdRBSX+xBxJcwcLkm4So15VWRzcyYzrBEqI47AJHu8l3cks+8tm9
	q7Q597cJAv17xuOWe1yYpfuf3eBTGKGn5GthUB08sIVht/QxF0SeTy5NYzFtM+Kv4gnoOu6M3zP
	t3U4oCYIXCbBvcc6JxoeGgrlun8RzEpYgg0/gVTDZWYEYpbpPK4GQfdetJFY5PoW1CiuxEQU5xm
	y2l5E3mu4DY+egZjJYMsfJ8DuIdao=
X-Received: by 2002:a17:903:1acd:b0:2b9:f59e:aca5 with SMTP id d9443c01a7336-2beb07eac66mr130317725ad.39.1779698161604;
        Mon, 25 May 2026 01:36:01 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b3bb6sm89301805ad.47.2026.05.25.01.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 01:36:01 -0700 (PDT)
Message-ID: <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
Date: Mon, 25 May 2026 16:35:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com,
 zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP1tCc81ascjwxJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/5/26 15:09, Christoph Hellwig wrote:
>> diff --git a/common/config b/common/config
>> index 4fd4c2c8af11..605a57947a40 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>>  export PARTED_PROG="$(type -P parted)"
>>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
>> +export INOTIFYWAIT_PROG="$(type -P inotifywait)"
> 
> Usually we try to split infrastructure changes like this out into
> separate patches.

Right. I'll split it into a separate patch.

> Also any reason to rely on the obsolete inotify instead of fsnotify?

fsnotify is exercised in patch 4/10.
IMO, exercising inotify ensures we don't break legacy stuff.

In general, is it fine to keep obsolete command/testcase from
an LTS kernel perspective? We did that a couple of times before.


