Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB433DB63C
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2026 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369042; cv=none; b=flZaw89Kt3E6+/1aSZDVExoCVfN/lnxuCBcQ0NuJKHfWTQaxOmdZ3+M23wOkB+PApJZexr4h7ZE4tOdpIFoIiz8tFSzrfwk6S8HaeXvg7rpssv5uU8dOgnofD7Z99kEEoupZIdvMA9eauK+kdbU6SaFCqJvkO/AsCubyPEGqzkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369042; c=relaxed/simple;
	bh=jX4JZvwPm/rEPVJFzf/ejOA6DjYxYRHfgyp4VE85mTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqLyEdAcNoYx3d5PmLy7PO5SbppqKJfre9EdDcCXm7EHc+GFK7Nkrek/erS0B6AlqvHBlS4ojbs/l4hLna+jicz85wHjI36SXUb4NryO/3qorElb0Mqcju4FbWO0rSA1B87FdmMadXErs+hCxWeeYCaZJO4rrK1OfOliXhx+d1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0gHfgbZ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0gHfgbZ"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8413ac3d82fso1397266b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 21 May 2026 06:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779369040; x=1779973840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G4yDEmmytiLp8y/IlWHiohedbGrR4sjKi+TCYvwlxxo=;
        b=L0gHfgbZ0lNXv8VzDT6T4RAlAMMWK8/8f3ZL92OEZALzVmq/w9h6nmxqTJ/EXHFFU6
         XUCxt0pAYX415Neyr3ZBVTEqiscISanap1vHo71qbPqOWFTBiWkoO7zMCXWWTO0wMGM+
         M5bTpa76oM3uLO3HBpSU/MllwaKcEAW9u4Ew+EX0obHRBIx8ajJntiH3Gfdg+pbu7AC8
         q9xtkKx3wSdZE1kuLkl2hzMH46FgDCNSAsFRbbAJNrIgtElZMmHHRbjrXcM0q7eoJbAm
         CjZFLoU+0UnEZnWfu1/qArHmJz6L5lwIlWpbNH7kTFkJoEj0fz8U3Vt2dBFOzmBJomIr
         Z5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369040; x=1779973840;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4yDEmmytiLp8y/IlWHiohedbGrR4sjKi+TCYvwlxxo=;
        b=lvyV7UjmgtbexCGeCFyl0D4HOjedsLY1qYTlU1bbAMshDl/XBo7MrjhONAzvPg2w/q
         VDH125c8+s5WgYKXf39Aa9AgiHOvVeOamOk7i6eCza6hAzSKDEZ/rMGMN3UrOQ28Nj33
         ujjvAUHXmqqhaR79PeIIv8pUHP1bUmKdrrDffmzcX1nW8QKU20Gmm9lxVUeuVdc9zf7U
         Ke28bRIgCCuLUg5umpGHPHezfJPIgdy07iX5O3CnltTxAXV8pBSKnvcdu/iV40aKBxjd
         vgt/nL9k8v8xulthFhb+RVXnsxn9bt+21ES6P7Q4t8/EEqicepOMy6fQxV1L1xypgcTM
         WVDA==
X-Forwarded-Encrypted: i=1; AFNElJ8gR0czLRaW7BjcX1y7aYIStjfR846dZnp8XA5/ACQtl83RSNgGEfB4Nq/7YSgZydqzGxCueEn/5mXx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1O3tDCl6zO8rDThIISbus8RoF8Nvb3sqCYxbt2nZzrvJ1bbDY
	vEDc+jK8i/hN2gui7RX34c3+DXAvQdqQEuPhsODo3Yu0y98I2IS+KZnn
X-Gm-Gg: Acq92OGq5AtybFdwfSvF1hHCpM61JSgJDpiqCHrcxFKXRaYjmqTWF4kU8rfvkn8DJoD
	/a0Lr365BIcY98/IoqXJ/x3WDB4NTL/lVlqviX7gjtdleIH8uerxr2mWKoWlfGKtKvTq6O31H+Q
	etokSHYj5rn+xIaggQHO32kWz3ktP7G6lIPLJEOR45+ywo+Y0OwMJJhyFYs3IwpB/1YTbJ7XlyQ
	k7TLvUW6nhgm0CkKMSDPYvR5npU3Vs0Wrkr0nKmqcR5JQX0UiAeJoND65Bteh/1z9gdzbw2pHwK
	B/K7fHiHpl9jTZLrKVB+/k9/3YZ1xKKsppVN16nOeC4HQior45du8zWG0upqZ9WJps7Ap/qWnUJ
	68f0pcrP94r+4AFYPZ8dwWN2KtNcZ9ZI8yeFs9xu9XcMgy6USHt52eGchesrzzzYSgvhqv7B9xb
	Pm+wlsFyPAmsNglKYfUUWAGIq09AA=
X-Received: by 2002:a05:6a00:228e:b0:835:6d99:3f88 with SMTP id d2e1a72fcca58-8414adf3933mr3055752b3a.23.1779369040007;
        Thu, 21 May 2026 06:10:40 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154a010d3sm1319228b3a.18.2026.05.21.06.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 06:10:39 -0700 (PDT)
Message-ID: <fbc03a78-0a6c-4c3a-9608-656d0df83d29@gmail.com>
Date: Thu, 21 May 2026 21:10:36 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/10] fstests: add pre_clone_tune_uuid() healper
To: fstests@vger.kernel.org, zlang@redhat.com, Zorro Lang <zlang@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-f2fs@vger.kernel.org, amir73il@gmail.com,
 hch@infradead.org, Anand Jain <asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
 <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 21/5/26 20:54, Anand Jain wrote:
> pre_clone_tune_uuid() changes the UUID of the golden filesystem before it
> is cloned.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 7ae9877918c8..1b3a32d9ea9b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1517,6 +1517,26 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +pre_clone_tune_uuid()


I missed the "_" prefix for pre_clone_tune_uuid() to match
the common/rc style.

Zorro,

If there are no other rerolls, can you please fix it at merge
or should I resend?

Thanks


> +{
> +	local temp_mnt=$TEST_DIR/${seq}_mnt
> +	local dev=$1
> +
> +	case $FSTYP in
> +	xfs)
> +		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
> +		;;
> +	btrfs)
> +		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
> +		$BTRFS_TUNE_PROG -m $dev
> +		;;
> +	*)
> +		_notrun "Require filesystem with metadata_uuid feature"
> +		;;
> +	esac
> +}
> +
>  _loop_image_create_clone()
>  {
>  	local -n _ret=$1

