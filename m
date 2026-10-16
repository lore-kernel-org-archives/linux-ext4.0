Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED775616AC
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171202; cv=none; b=jiVRSoEa5OHWr6bqXomqEw7vVvPyRn55fNM07EOR6z6CP9Jsq49+tykLSCIGbgj92LadnIADLmHBMT874RA6P0Ev0N0NEsy2ELqItJPOHwHD2jwW2Di3NVrhWkyQ7/kMP5es/rYiCJEytllZPOxLF3KYmXG9tuvyGEWwLrzTIcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171202; c=relaxed/simple;
	bh=cTHC0yfCpvz+ibcoG/JoiYW49Rvi7kVF4gEa7suZXJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPoFsESsU/zgFly6igwmT3nG1pYNWXrCCEERhGvLLeEuchFLb3Z9KYHJ1RvokGnRmrEZBPDrPkRJCErC5N5AGsC7hdOP4jBP7TyECzTPM0+i4/wqwznLpnmHDgbhmZ0LVSz4tOrhqVZ8ahOKlfbRJgH5QdU5PSOPses67xdwuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ma2Plbk6; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ma2Plbk6"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-88bc25fcd0eso116843b3a.2
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 10:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792171201; x=1792776001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uE2PjX0J6WzVcXk7jQ9SWzOLACgaklkDei11e3qQjvU=;
        b=ma2Plbk6gXZpxld6Gv2f/iHcnL9z/p91sI8Q90aV0hWwiufyZekex0Ie1GTSIndA7D
         /rnSmzUe2Pwrvcy8roBaIFOaaPmH99KEbMvam2MGzofG+vFXpcntmhzDqaE+kT+CILPx
         kokIOM1qDpMtMm8hGAr20xKoCpzhbZrDblqUNQCDiEyJfqDzAsHTOi2eCWERN5g1XY3V
         digonrS1dYADsru3qw6OsbU6VqqLQtH5cISpFmd3GdXy5eo3pv1OrUgsBPxuXs/uOYmc
         0kIBMTUHkcjkZX/dKPPJnkDattzOqaZFRxKFp9wKzvFR7+QSvLcbI1VRG08sTu1cD6ZX
         lWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792171201; x=1792776001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uE2PjX0J6WzVcXk7jQ9SWzOLACgaklkDei11e3qQjvU=;
        b=NOO4rK5vZxSqED4pGRWQ8ZocpzMmfmdBMr1kSI456R2pjCAL7EK1Lc7CWkq7dlUZUN
         h2rdVSy+22qGZFt2ryhS+EJtdB+CaihAgdUxKCokWCXtbdrBTpV3uofK94w8tSSGoj1k
         m4vQFqRCnymq3kmrPODzwR6CLo/ksMK+Rcu5CMXy0VLvxGRd/zG8v0GOH/Ba/Xs6daYT
         OFJweppdF4WZz9sddZmgINaizWNgNbrZXGPSIQORrSB/0cEeMrgM8qNuO3MecxjfMRv5
         fNqeMs3EGMKkV4cuYz5RGJzCMAz0wM9lp86SYeRFOL8Z2JZzuzgZ+9l0Z/2RJ1w6RhbM
         LVVA==
X-Forwarded-Encrypted: i=1; AKwUvByonxXa1DxkrvOz4aeoY8eyq2E52QJYkDG6g4Lqt105mUOEDdtbMclPynIUZ96qM0PQFJdr46M6cGKK@vger.kernel.org
X-Gm-Message-State: AFq9FYKGw/g7RPMVm0AG4awHyezIxRjgpCXSrCLxXxfyhX6f2dIiWKu/
	1YCDEqrNYTu26eQsaFr+U68ccjf+F9iCJNj6y27Z4LX7a5NC6mSbVRcC+3oLcYVx+w==
X-Gm-Gg: AYBFou0ePF81zYYPb/oXNF+HxPaVLXOGyHtc300MB8uYbRGg4fqeWoA/rShr1wHc6sA
	IoaiaUMqzCUWd4In9uh/Oj7WEmEWsn+81h6fdxfMRHKMZnmDMUPPjElW1uFavT+EXAYRhnSsA6n
	obya2VIZvF8XozHNSHaJi6cjVbydiiTjegDWnQtmqoTQ1voFRvCAPBS+sZ80rWYXO44A2uhs8Dj
	EvPQUz2wpcK1uXnME0AfVx6gj4+tALReemLRmgGa/TwGRyrpNNGxpqxu5gNc69Ptc15OhNp371N
	d12f7UQynPbFc7VI9GcyfoiTWkCSEUbNKsu2CFWmTo0/ihQaBWF0uP1LRa4csU70w3Y3pzYhI82
	NhylM7l29mGeINyqPaurgkFM84FOxVjQNdovnMmmQzAhEMp/QlhKTreop5JOTUOvresDN8tsqCW
	EJDItV89wcUjNvWQ5W9wN4FZqbfV+GYWPu8xIRYYemYDpPPxWDd0CcJqQ9Tp2n0IeZSA1sY3o8p
	MURIr9sqPMmQ1fAtts6I0mhnVEjRMBreSSaIiKh
X-Received: by 2002:a05:6a00:ad89:b0:89e:37b0:d1bc with SMTP id d2e1a72fcca58-8a04cb17911mr192844b3a.28.1792171200516;
        Fri, 16 Oct 2026 10:20:00 -0700 (PDT)
Received: from google.com (248.182.125.34.bc.googleusercontent.com. [34.125.182.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57268ff1sm1433387b3a.22.2026.10.16.10.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 10:19:12 -0700 (PDT)
Date: Fri, 16 Oct 2026 17:18:49 +0000
From: Eric Biggers <ebiggers@google.com>
To: stable@vger.kernel.org
Cc: stable-commits@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Subject: Re: Patch "ext4: switch to using the crc32c library" has been added
 to the 6.12-stable tree
Message-ID: <20261016171849.GA122880@google.com>
References: <20261016171336.3983051-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016171336.3983051-1-sashal@kernel.org>

[+Cc linux-ext4@vger.kernel.org]

On Fri, Oct 16, 2026 at 01:13:35PM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     ext4: switch to using the crc32c library
> 
> to the 6.12-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ext4-switch-to-using-the-crc32c-library.patch
> and it can be found in the queue-6.12 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Nack.  Missing prerequisite commits and didn't Cc the mailing list.

- Eric
