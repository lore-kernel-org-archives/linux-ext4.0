Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758F834D4D6
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358577; cv=none; b=lXgcmY8icBV3eHZ4SOG5wF4M4QNTLFWkCbRY94sInaUIqhi/h5hd3rFnhZYHo3I6VqKtq0M5JajqlqBYL+mcIXW13haEkPFBLHnk3j8LFwfOH9AraamuI/2inHc68gWmxt7nxZY1+EHPn1q4y0E4g5cSfN/RmsjJjuVjvvPzyIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358577; c=relaxed/simple;
	bh=fYJ5mHq4QmSl4hLr4psYfYMsXpthq+yhOwVDuodRaIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7mTJIVnfARehUJsyesTsrHe+D1Tem+N31b4RVB/ox1CcNhRbjHAZBuWdn7cMqSFYlZ1tFNCcQ4AC0oWFgPsKVXvTo/W63KRVdvv8culB2yO8gp8Jt5O8pwkqRZIMJ3U7sOmWjT9e3apuN0MXAv9AV3OjqAg4YSjR1e+EYlZx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tBHcnA/h; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBHcnA/h"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f68b3aaf7so4142854b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 23:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777358576; x=1777963376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJT0Q2+TNC0iQL2BZKm7PxCYejNErSFxDX4dcCZU2IY=;
        b=tBHcnA/hTkDN0WztdYUH4kvsFbM74MdUJDBMMWdZeygESyV2qZ5q4p9Up30kQ6dwyp
         XvACJHNVT/MLUWTkHORDbjN0rw4tOx23YJnV52/WHbyBK86N8PV9w96jmkNhiVrvT2Qz
         1+yPS3FX5il0WQjfcYA/AHcw1yKT6kakcGaEyS19OqV+jGoSdpVOltzEV+EJKlLdhJem
         WuVJcdmglXp8HN07xgUK+tKnPzlwWpZ6L+ti/SE7XqRIZlJnFjcnEG38j2DKHLfnFdvL
         ZaEyVM0WMngvP0vzBqWSrnx+kowZ3C1tnU7HX6ObZOnVKsx57QHssjB2lurLw+sLwN+r
         eKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777358576; x=1777963376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJT0Q2+TNC0iQL2BZKm7PxCYejNErSFxDX4dcCZU2IY=;
        b=mpXOndGUsS38JF+HVlzTsYnM84UL2h6B9w/x2V19xNTSa4LaVhfHrAA9F65bs6PYvx
         jmoGcCdujmX51QGycwGKERxy/FuiWnp2YuIGPJ0f2xND2IB30VqXQEuD16FJLh6kt+pO
         0nbubooGouveCHK2vNpuQCZroCLmQMxaPE2TfH8/ANRd4f5NGZzm1v3cO12+O37ASBX4
         D/V1EH9NuHDX09lhqfH9M+aODGJuJHSy2GL1e80Ha5jcWKc4cIGhamPE8CbrpVpaEJVZ
         SYNYkhY3051AGuVbOrDoq1BPs/kYqPL3y04seaMlMG+Xb+7ctB/4Dc2yFzddxqoieiRf
         VoAA==
X-Forwarded-Encrypted: i=1; AFNElJ9uJw0x4m+pPGDSQnnE5701S0pqlLHUT7OPJyPxcdQuEGKdmqP7WniM2yktr7ANBrgWlKAmFz6BAA+A@vger.kernel.org
X-Gm-Message-State: AOJu0YyBtxKv16p8j2iiBItUAfDDPKvFfboQzzDBqMxx/9wKPGs0cEdE
	XLhL7Df9AzUeXBA1UZCGl+yGLoXvqT9gYkLKlc2JYo5r12nsNKoj+vLL
X-Gm-Gg: AeBDievjHUxE0Q/3aYMIyKm8EUAJeix2D0ToLclr+CzP1+3nloDQfbcOfDCjRQc8d0h
	DVFajrcB8gZY0DWwPafLD9+IbDkUdO19KIVwaYjFBXk+NMPryExDTL/f+EEIU6MbDT+xuAmduYg
	FM7+LjP25bfH8CU7bpDc0U8SpVgKhBOfXF6ZCS+PSDW2TD/Sn74c3IpGFOMxmbjlNZiRnmHU8XX
	WYU3WYHUBQr6Krpy15AVG6TctA8sLSKwvUW7AG3d7tVu5zhn9IMOEd/rr3aw2t06aY86LJ9LU6E
	7K+GYIfsuAKdJmMAaP77STRz4sPxwSdQYIwv2DAhrCncjAwGNj6bj3CsHzmSv36OEZtfCPQZE+i
	H4beQFnNb27pY8GZBWFP0ccqk1mWWHPt1WXcmdifVWYPnnlfiYHmCWZTGkxfEUsHVJGX40PMMdg
	yUNTVrGjdLcgsVxe0D6W2IkK5gxuLWFau4ChpZNA==
X-Received: by 2002:a05:6a00:12c1:b0:829:8c08:d1f4 with SMTP id d2e1a72fcca58-834ddbec0e6mr1846825b3a.39.1777358575700;
        Mon, 27 Apr 2026 23:42:55 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834dae07945sm1904377b3a.9.2026.04.27.23.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 23:42:55 -0700 (PDT)
Message-ID: <71447b65-0390-47a6-b0ec-7727a3009256@gmail.com>
Date: Tue, 28 Apr 2026 14:42:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
To: Amir Goldstein <amir73il@gmail.com>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
References: <cover.1777281778.git.asj@kernel.org>
 <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
 <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 28/4/26 02:31, Amir Goldstein wrote:
> On Mon, Apr 27, 2026 at 12:19 PM Anand Jain <asj@kernel.org> wrote:
>>
>> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
>> image file and clone it to another image file, and attach a loop device to
>> them. And its destroy part.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 9632b211b58f..0e7b7eb1d98f 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1503,6 +1503,50 @@ _scratch_resvblks()
>>         esac
>>  }
>>
>> +_loop_image_create_clone()
>> +{
>> +       local -n _ret=$1
>> +       local pre_clone_tune_func=$2
>> +       local img_file=$TEST_DIR/${seq}.img
>> +       local img_file_clone=$TEST_DIR/${seq}_clone.img
>> +       local size=$(_small_fs_size_mb 128) # Smallest possible
>> +       local loop_devs
>> +
>> +       size=$((size * 1024 * 1024))
>> +       $XFS_IO_PROG -f -c "truncate $size" $img_file
>> +
>> +       loop_devs=$(_create_loop_device $img_file)
>> +       _ret=($loop_devs)
>> +
>> +       case $FSTYP in
>> +       xfs)
>> +               _mkfs_dev "-s size=4096" $img_file
>> +               ;;
>> +       btrfs)
>> +               _mkfs_dev $img_file
>> +               ;;
>> +       *)
>> +               _mkfs_dev $img_file
> 
> You making a wrong assumption that FSTYP can format the loop devices
> 
> You should add _require_block_device $SCRATCH_DEV
> to all your tests or maybe nicer, add:
> 
> _require_loop_mountable which requires loop and block dev fs
> and use this requirement instead of just _require_loop in all tests.
> 

Thanks. I've fixed this in v4 by adding
  _require_block_device $TEST_DEV
Since SCRATCH_DEV is not required.

I didn't create a new _require_loop_mountable() helper.
Both _require_loop() and _require_block_device() are
used both together across other existing tests;
I prefer not to deviate into cleaning that up in this
patch set.

v4 is in the ML for rvb.

Thanks, Anand


> Thanks,
> Amir.

