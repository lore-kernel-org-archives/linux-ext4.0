Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F82DF6E6
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 05:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773983562; cv=none; b=nxZ7Hwp+BBL/HojkegfTrM8N0o+a0uVpKw4zCryDzZa/JO577AAhfWGKK9o9fdV3u22lTzI2azhBLVrEaswoIaJxYte9D/9bdLwFn3B8M9rN6ixZYbvaSqeYZTTAnXS950qAIZX66XkSRX2IM/zzUyEo9HPNynPUwHqv2xmrYSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773983562; c=relaxed/simple;
	bh=EVxsGF2JMx78s6vGfm1dnPsILWqubQVs8xjak0z7u3s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JzbC2u70AN+Vz9+1CJLDFtEmoCVhi2sBE0+MCJAJ0dH/JVzuijWPRi0jdTQTqzGFwmT8DhXjOEOCEBbDL0wSmkB3Hg8frjsn4X1juMgDgek8kPSwAaWZNHwvho00826aUIW6zp8ZCtpcw38HQnEBSgsPAMJuFRlumPQrWzUnzoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=VBhUMb41; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="VBhUMb41"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-824c9da9928so1464607b3a.3
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 22:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773983559; x=1774588359; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rG7jjdThjpAvZ3OM3fiIAir9QVeVGL5dlO6ES5/Ehv0=;
        b=VBhUMb41Y2khI3mcpSlI7thNrVoNDltaE6qBpsqMQODBxPyUvbTDJUmkLz6rlvW2yq
         4mnX1hR/Ox8iW3FiCvs665zq2lV9UJv6aKYPS764dW+yp5JdRJ2LSJlM5UDCuE7aqdqD
         8YjxJTZaafv+xbOOUsrVdv8aLaY5y8q/Q8u4ZHtMGKntfnxwdchtdyhcKfzmosbt0bN2
         nZS9Ceql7xRP09AeD6p6j8ekNLTeLnfNcQpc79sHuJnaU9EeNwu1fJl/zo9dhHHCiZI6
         CDwnIvKJo+tJMrAL3oKCP84RhHkYp6Bp7p9W9Cib2mPwsx/iTmtUiqUTsmOvBNHetx4O
         Gd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773983559; x=1774588359;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rG7jjdThjpAvZ3OM3fiIAir9QVeVGL5dlO6ES5/Ehv0=;
        b=WTJqPkzSn6GkYXqdgc06YFN/kFaFW9WxYFsbjMRTmhhlORa3TVEhQRDxim0MaQBH4+
         lvwZGpe+s5oLKgzIPUKofrYLL/qy6bd/MYCTyvGXgb/5VR5gjIjPy19j4RFBnV5hNbxs
         guIYRLhbuKgmh3C2vZ+0BS5Njc03pUgcYvirsTkfH2cRcoFKRiNsvfMpBb5ybfMX6sHp
         foQfNXCq8TSu/Yn1+4ujw4ZTypDdt0A1YoOeb0nvHQR87MLGikmI6oYPNEPrjZpInJf/
         h/wnp8aj0SouN0NnnoE2EAzN+ikCXJrycQyWKOTvkBFpta+/T0BtH1LiPODwdwQ0LzwS
         HqSg==
X-Forwarded-Encrypted: i=1; AJvYcCWijVH2DcpExRWBCOwXzuRfSWnlU0Qw/2YbMwVybrkmNfzoKCCzenIwJFD1S189yDFu6HSUvGfyaWvg@vger.kernel.org
X-Gm-Message-State: AOJu0Yz93uOT9q37mkqlQmhcLevsxOKPYTzg+Prwb5CkQq0g8Mav41pJ
	G1IYtXO3aHZ4LPdsyXUrgmlbq6CzIB1aEF3OG7EEloGgJUa1l3448jX6o1lJNuP1M98=
X-Gm-Gg: ATEYQzzpxpKvEI2R+4x74HGJI1DkCvDdz6VIiNe8PW7bqskfaXkkRwGT//059VB9y+L
	Q3RxOSaukxOJ5OheSfmpGgLlhUl/hwyuB1JBQEQ5n88ThbNqy9txQ3UcltEEDyGu2DJInQNi6KW
	U+Fv/H2gXBq2rKKdTk2PRLs5zxm4KUkaQM+s3DEbb9bVWZgmZMOcmtwfMEp+8KU0pjMMqQDfFb0
	aTLV+Wspv5TOc/evxf/35XMjMPD75beiev/I6m71Tg0qG8kdyA+jxfc/AwHDegrVkz/Kr97u67R
	c4BnCY8o0rgoNJdOFQoUIPtqtloYrMoSEOOBgai/djLlNjhJHwBIa4GXp8/mtp79KBW8D6ERp4P
	PrTEkhy5w/zkShi9fGRGL0QQHTIRIyUqii/PdmrJT9ldZID/5bRiA2vXeppLuFbZksQavlkc/xc
	silVlC75Zsu15VSZafzRtpKezSOGxk8aBTaT2sUgarHSkz6RYA0J9bReOLZmLtUIX9HCXSgAy24
	448Ew==
X-Received: by 2002:a05:6a00:2d12:b0:7fb:f87d:a0aa with SMTP id d2e1a72fcca58-82a8c39ed6bmr1416593b3a.52.1773983558805;
        Thu, 19 Mar 2026 22:12:38 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409f409sm810571b3a.31.2026.03.19.22.12.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2026 22:12:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 2/3] ext4: add ext4_fc_eligible()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <177396306176.3934327.9167241352093307006@noble.neil.brown.name>
Date: Thu, 19 Mar 2026 23:12:26 -0600
Cc: Jan Kara <jack@suse.cz>,
 Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B981C6F-1702-49BB-BF0E-44A3955175EF@dilger.ca>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-3-neilb@ownmail.net>
 <gh7e7uykczpyhfxrh6y54c2jlcs4pzcud65aqsjoj4am6cajzp@wq26crdxv2yd>
 <177396306176.3934327.9167241352093307006@noble.neil.brown.name>
To: NeilBrown <neil@brown.name>
X-Mailer: Apple Mail (2.3864.100.1.1.5)



> On Mar 19, 2026, at 17:31, NeilBrown <neilb@ownmail.net> wrote:
>=20
> On Thu, 19 Mar 2026, Jan Kara wrote:
>> On Wed 18-03-26 09:39:50, NeilBrown wrote:
>>> From: NeilBrown <neil@brown.name>
>>>=20
>>> Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
>>> ext4_fc_disabled().  The code can be simplified by combining these =
two
>>> in a new ext4_fc_eligible().
>>>=20
>>> In ext4_fc_track_inode() this moves the ext4_fc_disabled() test =
after
>>> ext4_fc_mark_ineligible(), but as that is a non-op when
>>> ext4_fc_disabled() is true, this is no no consequence.
>>>=20
>>> Signed-off-by: NeilBrown <neil@brown.name>
>>=20
>> One nit below, otherwise feel free to add:
>>=20
>> Reviewed-by: Jan Kara <jack@suse.cz>
>>=20
>>> @@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, =
struct inode *inode)
>>> if (S_ISDIR(inode->i_mode))
>>> return;
>>>=20
>>> - if (ext4_fc_disabled(inode->i_sb))
>>> - return;
>>> -
>>> if (ext4_should_journal_data(inode)) {
>>> ext4_fc_mark_ineligible(inode->i_sb,
>>> EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
>>> return;
>>> }
>>>=20
>>> - if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
>>> + if (!ext4_fc_eligible(inode->i_sb))
>>> return;
>>=20
>> Here I think the !ext4_fc_eligible() check could be actually above =
the
>> ext4_should_journal_data() check - if the fs is not eligible for
>> fastcommit, there's no point in marking it ineligible again...
>=20
> Both you and Andreas have questioned that choice - so I should explain
> my reasoning.
>=20
> ext4_fc_mark_ineligible() is NOT a no-op when the sb is already marked
> ineligible.  The code updates sb->s_fc_ineligible_tid to the largest =
tid
> which was ineligible for fc.  Then it only clears the "ineligible" =
flag
> after that highest numbered transaction has committed.  If we skip
> ext4_fc_mark_ineligible() because EXT4_MF_FC_INELIGIBLE is already =
set,
> then that flag could be cleared too early.

You are right, I didn't understand the ongoing effect of FC_INELIGIBLE.
As you write, checking ext4_fc_eligible() afterward is equivalent, since
ext4_fc_mark_ineligible() is itself checking ext4_fc_disabled() =
internally,
so the added overhead is the ext4_should_journal_data() call, which =
looks
pretty complex but is just a bunch of bit field checks (though =
potentially
adds a lot of branches depending on the frequency of the branches).

Cheers, Andreas

