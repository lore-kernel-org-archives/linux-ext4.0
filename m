Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F242E8DEA
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782996338; cv=pass; b=TIe7zHc0qDkGa3fbFIWPTmt27xf8Ep+9Zy4pVdyQIoyQr0Oa9HBQi8UHhQTB1JEDP20R1UOmzsTv0rB93qqj1syCxb4ZMuNTLK2kLv4IHJDP4J2Htt+xCFZtjuTV3sRjSKXiCeuJiGV5Mr4xIw4dBdReb0BfG6hxFwETlMIjUg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782996338; c=relaxed/simple;
	bh=YfuTP/ZRleT5u8JPEbY+mg8sn8oDE1H48dUxEJLwHHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JHCpw14tuVAwCT1U16TdQ+l9aUldglZ6lBqfHVGAFhWZTJlMgOu+V9bWK9n0lFDkbKCpvQtcmJs3ZULxZ4f9jzSoB2aB/PFj83hWchl4nLnmd3sg5kkY6mhDVXXdjF9NRD4iq1R7QmAO8Px08v8Q/b5WvXByMwMGLs/2Pv3Q3kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stG3jPxX; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stG3jPxX"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-664c1406f91so2313729d50.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 05:45:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782996336; cv=none;
        d=google.com; s=arc-20260327;
        b=E84tGEl12VO8ncbjea2tSqlfkq+BdVFCB5t7DUm7yJNJny0FVKNnRYA2h+iD9/IgQn
         CH54TpT+OzutcaV1+vIVFOkoik/7qs7LNMwlPu1ixBEtXGAaVLOv8RmDYfxzEWf4uG3P
         s+JMBvLuwpCCvpxOr+/CgDD0Wg/5smYU+1sgzFLc9mL8Yf/h4iJTgyyzHdFdsS3aJT4r
         jNHXxDplLd8brsOUM6UOtf8usrPLVht1i1l67QaSNbd7s8swv3UZmg2+AIyaec2q9wJx
         MQkIrPr18/qAw4DzeH3sOTVIuXkU1BHTZig3zhudmjE17IQIOvzk7fLXwgpYaoUCclMe
         r3xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1LTF2zi6k8qqnOoUHhbldZF0g+S9mvdrS4GbbTxAt6U=;
        fh=+L2EGknUahx40oxvDI9cC24NF/J/yhc1dee080O8nEs=;
        b=GzeVUGp9oGl0t7nwUmCMzFTNOuALzPp0VryAJoU0a7Tdt44tcE9kof7/qVMnGqvrwV
         LwY41vydU3mjmrRgLCepiBovZZ/zFZQ5EP18caWV4DMGsRd+f7ZYZEMVG0wJngDlWXEQ
         tS5wgmoxuFplT/03txpHO9H75bxu5Zt7fjVHlgPnQOKnifA2/karuNkmem58WNFCdAxl
         xteBHrE+W7NPGnHisjdU570o0sOr3cjGjtPWxdroues/lE08Zj9crisoWViMmSOvAQgC
         TEsNd+Dw8B+dfQ1iX3t7pF+xoNmJ1fmmmDJF3vUiLKLxpEIILZoc9mP3Ph7oi3LbjgM1
         l2vg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782996336; x=1783601136; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1LTF2zi6k8qqnOoUHhbldZF0g+S9mvdrS4GbbTxAt6U=;
        b=stG3jPxXPnMRcSQjMNoyaY7Ikf81aZtjiowVDv7NA9ilAqjcWnbAxtfiqqm4gtGFtJ
         2MSXxETFrNqDf9zRV3E0wF9h3vCR00aY+zBwnyZ++fRtHdsqE8FeubfXot4HcMfQgLAI
         TfOlqSWNeCCCECD4GtvrIZhxBDv4AVSJp9K3WkRWY5Gp59YHmZ3eZh6QCDjVWFZexsJg
         WzJUg49Ysa5YHg15oXMLkAxZbV2eY/E5dpeY/9HBpYx51c/9z04smPlMDjkEQ+KooZ9t
         Ly0avz/dYpOzYcfNddtBy+2/empiTtsPg3VuuSH8iJuXfKj5N04GWf2kWPcb5mk+QKqM
         lqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782996336; x=1783601136;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LTF2zi6k8qqnOoUHhbldZF0g+S9mvdrS4GbbTxAt6U=;
        b=UcHuaLz1gOOHOYFaAgRuxrRVsA2eY6qy0qcxagbjPUrd6KsPARBKMoPUxWyu/KjjCK
         YBrJNkuczewS9Oq6aO5Tv52WT5rEsN2L10oOztaP33QNbeUN/E9msM7pYS4cwPniMeXU
         PphqoOKChzlh1vmYGpiCvVI5iXISnco8+jedxxT+McT3btERs/yGUmDLHbHBUa2gTIvd
         Niv2Sa8vv25LRrXrwteKqD1rVM4DGN64M1d1VJDpm2NJJ7GCC0DkkaanQ0ANJo5bK0PN
         pzZ70aBxyboN8VN8JuwPjKLcqPoWHIx97t9U/NzPcrlpqdTudVZJkwyHD5DQ2YBZ4rH8
         pXAA==
X-Forwarded-Encrypted: i=1; AHgh+RpRwHHFV9Suu8GsnA6I1iT1T528AzReoy86G5AxFgQZJ3xU7o3uPm2Gig0iLiIr4NBRMKh+yn4ypPHh@vger.kernel.org
X-Gm-Message-State: AOJu0YxNjbSkW/9bXXgBwV0CWFIAi2tizo3AyTOzUyZBfg0FLzmEG+uo
	4T6Hl2TPnoMvMilsXzaDmltKP6Iy82DXdcZiM7DgTEl6V2v1VFCiEjCdZ8hnJysNvrEb1qHthia
	F5Z6Ism0u6ZYmbm6RGGS6CGBaCgNR9FA=
X-Gm-Gg: AfdE7cmqR20uJRgzNbaO2662edqVyXpacQzU9NYz0JxczB63Q8wDx5y/t5vtz4katvv
	PJlYsnYNy3fsz35CnDkVaSQf30mtQRAIjUkImUVzesIujjbX+ptPmzr315NovdEGnco/LM3KilU
	IDPez0Dio33+FEGfM0TluLW6Ic9Zd/6n3LELEadf6/BjJReX/sBkV1mWjW4vD+nFBk/ytpD+MYR
	a1ra0puNut/MwlfTG6QHRsvQa1dMOBMbb+m9hAULevc+Ye5s77AGl3kRwzFId6puv8sycNLXMix
	ioDm24XUTD1Htk7eChD+hRhrxqwXf6I=
X-Received: by 2002:a05:690e:1289:b0:662:dcc4:c6bd with SMTP id
 956f58d0204a3-66521a6e36bmr5861205d50.34.1782996336401; Thu, 02 Jul 2026
 05:45:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702050724.1658-1-aditya.ansh182@gmail.com>
 <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
 <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com>
 <zwfhyqxdxfigm5nced3hgsp4mygwxgwc4cxzeyl7glrmie73rm@r66bdrw7fjsj> <CAK5ssPPPfkL889aCK_z9EnDNbKBuHRQd45uLzXpeUVrVkFkzbw@mail.gmail.com>
In-Reply-To: <CAK5ssPPPfkL889aCK_z9EnDNbKBuHRQd45uLzXpeUVrVkFkzbw@mail.gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Thu, 2 Jul 2026 18:15:21 +0530
X-Gm-Features: AVVi8CcVo-eNxK1YaN3wDQSM42J7VF1rgCK8uZiy3AfWHDTqxEpsOP0UeyEofZY
Message-ID: <CAK5ssPOxredbV5dDsyc4YLdDBVPEv5b6qOKCxiWPLMWSc7VyaQ@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: use fsdata to track inline data write state and
 fix race
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jan,

Thought a bit more about it. Treating fsdata as
bitwise flags rather than mutually exclusive enums is a much
cleaner and more robust design. It completely decouples the
different write path states.

To implement this, I will define:

#define FALL_BACK_TO_NONDELALLOC 1
#define CONVERT_INLINE_DATA 2
#define EXT4_WRITE_DATA_INLINE 4

This ensures that the flags are fully independent and do not
overlap.

Regarding unrolling the state on exit, there is a slight
asymmetry in the VFS interface. ext4_write_begin() receives
fsdata as a pointer-to-pointer (void **fsdata), while
ext4_write_end() receives it by value (void *fsdata).

Because write_end() receives fsdata by value, modifying it in
the write_end handlers has no effect on the caller's
(generic_perform_write()) local stack variable. As a result, a
stale EXT4_WRITE_DATA_INLINE bit would remain in the VFS across
a retry.

To handle this cleanly within the constraints of the VFS
interface, I propose clearing the stale bit on entry to
ext4_write_begin():

static int ext4_write_begin(..., void **fsdata)
{
...

/* Clear any stale inline flag from a previous retry. */
*fsdata = (void *)((unsigned long)*fsdata &
  ~EXT4_WRITE_DATA_INLINE);

...
}

This ensures that:

any stale inline flag from a previous retry is cleared from
the VFS stack variable before the next attempt;

the FALL_BACK_TO_NONDELALLOC bit remains preserved; and

if the retry prepares an inline write, ext4_write_begin()
simply sets the bit again.

Please let me know whether this write_begin unrolling approach
looks good to you, and I'll submit the v3 series shortly.

Thanks,
Aditya
