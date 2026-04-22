Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EBF372B2F
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858003; cv=none; b=rqGsIe5+vwZD0BWMwtlDm0HXMAr8HMun47sLQjdPYsAkziCWkZ76QP+KycK9vOm937zaGO7qVwZwf0eBRlY4dkWswmi5ZEGw8Lx1S0kziYbdH2abb7bunaY0Z6prIee1zWpDLpsIU88GLo9SN0WPAEwBbhrUXGYmSFSXQTkVHoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858003; c=relaxed/simple;
	bh=7jSkwPHB1rmAue0G4ep5X5x0tFp0MCnjlBuXF0HrV68=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rG2ZplUFfkZ5EpKVsk8/oucc2SPxAagyIiB3rJJcHi7IgKkunXvNMOT6ALEtw9s8Mfz+4ip8jdA+jynl/RncIy2lBGnJ1yPkhRm1AHFzBLJLCXtgkmnt/1vA/Q5nkxanENFpIm43HS6Lffu3EWQX3sNgG0q6EVP3m9R5kENfa64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ll9mgn/J; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ll9mgn/J"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso3247992b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 04:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776858001; x=1777462801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MUHkTSAzkxq/Om8+jSsUbp1RMELRmuD0B/+VrfsdgxU=;
        b=ll9mgn/JnyYFNKhpAt/qyIgH1H+6MCuZuRMt6NoafZGs++QWkmwE9ELntcK6j2aZrs
         bjQDiQFaXB2pDrlBOV1aoPlpvtUlnweGGbZMAF9Q7qAo54WB+4r87Df9qK0m/MFglUBd
         BHMCkiou5z1IwPYX5t+7wdQ6N9NGl5PX0SBC+LSXK8JwUi9vyLk0h5QApWvWmE1B/ym0
         SCtz+viyfmXeVbo/hLcsa8mfFKnC4LHSM4xJtetEzCH1GXbOMkQiH1fScUiEa/qYmSFM
         gZv5DV9WtfS5UBKC+jofPgs7h43TRT0mP/GxTto7wBYsxzUMpgxu2N0ZTl+YyPksLurO
         u+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858001; x=1777462801;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MUHkTSAzkxq/Om8+jSsUbp1RMELRmuD0B/+VrfsdgxU=;
        b=XpD31HjDgdFSH4ZzpoTaw6GafR0kCat+SzUGzU0R9ec4CKYKdNRI+FyI9bnCcsJQIT
         KrP4AWY39ZR1vR8xv7AT3oHRZtSIFwxK4LOhh6T1iyABBl1xsHdnAav7Y5ePIAtmLy+3
         tkvjWKZtCd+xxLu0GEATAe1SioCCSXejhmYnIWh0jyhW/r+lYQWAbyQuS76VfcVzwHmS
         WrurzDV339EF5uTjh9y2AvmpysSQCMuiyfg/33j/RPjeSQZ2RVPyeuG7WYcdy8FB5b2q
         WX3WE+w2sOhQ089WLDgBuwCRNbj5e6G0MfoZB8AlXJ/R9xDfIV3OpzfDl06zeb/c33q9
         SGKg==
X-Forwarded-Encrypted: i=1; AFNElJ+/L24Ie30roItA+nV/pFxDlx/0NUd/i7cp5srxNurYtmnmwpAg8M4xE++tMfdKR6kqS85KWapIJ8MW@vger.kernel.org
X-Gm-Message-State: AOJu0YxYZ7bdBg7zNx8R1Lxs7vsHyPgYm81IHKttxlBl3/IiaUZU9MYE
	cynRu8+ejwalW1PDxfVukLYbouDbzA+TE5LruRudn6LHvSk+Secyha/a
X-Gm-Gg: AeBDiesshQBZEcE9Ikq/28j/KKr9/uvw1O3/jBFy/IBZjPVtwOWvGYYg3L8LUdfFlfY
	rJXqUzJYorXVSUzla1z6Fus/KH+/vVJngKTm9J2V8F2RwU2xZkKIFc1OvsaB0XdU+RzvYVrwBpn
	k6HexHRVMPU5evDRNN5+ecZddvqBXQiNjA8E2JptUZI78FI5yKnAQjU0DjAJ345QTtvBNLEZtYd
	oNsT0gwHAvQpE4ncO8tz2BlV5grX9OgaaAb2n6zRLPVgAUIblFUyqijHBt2X99o70F2AwzHuTD7
	XB1uuZfs+/lsvECVk5cWNtCHt0T0O4sELXDHn7Hv3LGqoqY7Q1YaXNN320mjtH4aZTpMCkTNMjX
	gE5Zq4bBxMQs/MK77GXm50dYyLypy7Ew5ex2Y9hlwVad10YXCjmoaEI+Z7Pdd8R7skgxn/0y2B7
	cPO3zqLH2hl5So0/kMqCdBvkWX3QLm9ujxQM+C+g==
X-Received: by 2002:a05:6a00:984:b0:82f:2985:2094 with SMTP id d2e1a72fcca58-82f8b554ebemr18415296b3a.30.1776858001175;
        Wed, 22 Apr 2026 04:40:01 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0092bsm18335315b3a.50.2026.04.22.04.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 04:40:00 -0700 (PDT)
Message-ID: <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
Date: Wed, 22 Apr 2026 19:39:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Jain <anajain.sg@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
 <aeHikJwRmFdDg5FW@infradead.org>
Content-Language: en-US
In-Reply-To: <aeHikJwRmFdDg5FW@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



>> It seems we've reached the functional limits of f_fsid.
>> If we want to solve this properly for Overlayfs, NFS handles, or a
>> complex system monitoring..etc, we need a new identifier let's call
>> it f_fsid_v2, that meets the following requirements:
>>
>>   System-wide Uniqueness: Must distinguish between cloned filesystems.
>>
>>   Persistence: Must remain consistent across reboots/HW re-enumeration.

 My mistake- this should be:

  Consistency: Must remain consistent across reboots/HW re-enumeration.


>>
>>   Non-On-Disk: Must not be stored on-disk.
> 
> The third requirement doesn't make much sense to me.  If it is
> persistent it. or something it can be derived from must be stored
> on-disk.

 I hope it make sense now with "Persistence" replaced by
 "Consistency" for the 2nd requirement (above).


>> One possible implementation for f_fsid_v2 could be:
>>
>>    f_fsid_v2 =  hash(s_uuid, block_device_serial, [subvol_id])
>>
>> For pseudo block devices (virtio-blk, loop, nbd, brd,..),
>> the serial could be derived recursively:
>>
>>    serial_number = hash(backing_file.f_fsid_v2, backing_file.ino)
> 
> What i the point in this?  All of this seems to be better served
> by s_uuid.

The goal is to fix duplicate f_fsid issues in cloned filesystems
by creating a unique, reboot-consistent ID. This allows the
source and clone to remain identical (sharing same uuid) while
still being individually identifiable.

>> Note on Hardware Serials:
>>  Standard storage protocols (T10, NVMe, SAS) mandate unique,
>>  persistent serials per LUN. While I've seen T10 protocol
>>  violations during my time authoring Solaris HBA drivers, I
>>  believe these outliers shouldn't dictate the design.
> 
> No, T10 does not actually mandate unique identifiers, NVMe does, but the
> implementations are often totally broken.

Right. Newer SPC-3 (and above) compliant devices must support
the Inquiry CDB EVPD flag and provide page 0x83 for identification,
which is what we typically use for multipathing.
These are globally unique. And, we can overlook legacy
drives, as they've probably been past their EOSL for a while now.

We can tweak the algorithm as follows:

  ID = hash(s_uuid, device_identifier_id,
            partition_start_lba, partition_end_lba,
            [subvol_id], [file.ino])

This is an ID which remains consistent across reboots while
staying unique within the system, which we can use it for f_fsid.

Thanks.
