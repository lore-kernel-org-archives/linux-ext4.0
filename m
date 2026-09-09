Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00228505E
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 01:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916519; cv=none; b=l2ihqbWw56nXGR9+EpRVKJvvGA/xy3kqb1UQvgfD6ZJbRd71SfAyX8tUhpmfF0r7dsgAJN9x82q3o2/+TTuvy6ldldZppHxUpzYGDoH4Y8fJQmRXrS6+0ZP6PiX7NmkfRndi23ErkoJe3qbchXgN6fIw71H0/KZ2JvjzhTwG930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916519; c=relaxed/simple;
	bh=z88fBECguwFUQ3oqHlOVu8JMuEaPOtdR+gKmUFDZRQA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=TtY2QwWZ+Gq2EK+1qjQ2aslC36rPeXhY5zCNe99OR7lBNo+gVQ9Ns08EOUn8puER0/lB+3Tz8OrWb2o82dn8XZ7q/iGiCh1f2FwBwwoD/aClptXG2xZ3QYPq5F/7yBzvioLwIbUCB/VzF0AGFLqo+J3RQ3vl55umrZH29mERmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zCJZb78p; arc=none smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zCJZb78p"
Received: by mail-oo2-f43.google.com with SMTP id 006d021491bc7-6b1ae739df5so402874eaf.1
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2026 18:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1788916516; x=1789521316; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C0F+BhJXWav79HJUvCDEB8apDuPRzW6Sy5FYxm9DXY8=;
        b=zCJZb78pZbogNRl6478FadGCvHkH3DSVPHCVkwxsJeIWNmnsuHjejJEDQRV0tXcq5W
         J1LvDH9Fa7OyX/+I+Y2fzPgapAOdOCkYGJtfHNRUEHPGMFYJiNsjIz6MWN8Heyj0Gh+1
         g/SfhEXdZ+ysdKncLzXYgUXoM6o0buD1agMO04ECfN5J23MvZb8TFDUMZ6qhll38/R6f
         ov5ZFUPpVEtp2BIWVZfQDwRFSvdNx9izQwvShQWvUb13KQD+orZvzeEdc2SnJ9U9uaCf
         x2OWi0akDWHh2OfD8gkGkXLsBkVh7eUAiM6QZ868QsHowevjig3nEi3i3JTYwmUd+rrj
         Judw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788916516; x=1789521316;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=C0F+BhJXWav79HJUvCDEB8apDuPRzW6Sy5FYxm9DXY8=;
        b=d+1XCTA0pSvyflkG7O5kAYxdJE/1GFpi8U7s18ftLbeph+tR33cALNXptb2enj7u5P
         3kp0FeWncx0CrFDdOnUUvf5axmlVx59LGVx98q5B1Yg46DBegSBUGyv35xTWeAz7E+E/
         aoT6QlrrFNyQzh9w5XuD7aoQJbwcRnmrYfoz2PtqPF4T3IbWiVAAX9Z9+GQyLPCLfKlK
         q8F9FiWdb3J201hkeUdG9Xeoz2z5u0rkVmsoaGthljmJXsSlDAcGs/tbPFvxU0B/Rali
         AppnupTZPJubT8kvaiD95kHnjBMKiVfgwry4+uQ3nN9Hpt5yFy8IPkiTa21O3/LEPXfd
         DOBQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1c6Bq7m6emfhiPnuw/nGchwc5q0b++L5AQPnvcqf4FjKH1qXd0jt3v5B8KN9Kf6L4Y6ekoiXcr8nQ@vger.kernel.org
X-Gm-Message-State: AFuF++l8AvocCmYvxq2WOJLdB3z0WfHgt+D6k9qnlHSQ9xRZflbj/WYj
	kA814Qo4UaVU41UVQZfbIrK9dwmFhX7Z2edFbU/JIDIVwqykwfvR7EKsfa7mfuW289cTPjYie2r
	7OQMd1Lc=
X-Gm-Gg: AYBFou09M79a8HTtbZ4cwXjmkJniWyzwgLPc5HDQtfgN2iKx5YId4gXYuyzNqc7DQgq
	waDDXQR3ahT1eClwvA9j+L9cJA2phE9vrIHeFkOgtuJHfNJ9VMZQ7PVr/YGILq+Czp05DS8Xd1J
	EBS5SLMXN4uYC/A8Nm78NNnexWUuaUT39814W/NL4yLgXliA1THLBimnZLfUNh9xyoQ6w1ytoJn
	Z0mzSsvXyK3zsWlu/X4GhLqwPZr4lhfhFU4moaF+MG8uYVeZzxQdCCJZLU4VsYI7JFFBsqtoOXW
	s8GA+Plztd4eZc29RvZ9pHWrMjjtL5LYriFLBQU/MLG/r8eNrdvgppWvytK93oxq5A8cHmAjzs2
	fi0ZHMbxX2dIJpd2W7czS6BoAGT9iHi1w0nQSW5LqHLH7CcGfZVcS8iY6KYiTaIqFZfyIHLr0Ag
	KaY8ANYB8JXWkD7z2aFr0M1b445IAu7aWgCGCpq3ExV2tqcff7kMRS70GqOjK3+BGZq/7eW2c4O
	N7zzCtE6atLV2Sfm+IhZfk2xQ2fJMCOWI92879F8xfqeZrXUqChnRvdZg==
X-Received: by 2002:a05:6820:8595:10b0:6bd:fd44:9045 with SMTP id 006d021491bc7-6bdfd4498c6mr636514eaf.3.1788916515696;
        Tue, 08 Sep 2026 18:15:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b6dbedc6a0sm18374727eaf.5.2026.09.08.18.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 18:15:14 -0700 (PDT)
Message-ID: <b191cba9-d863-4bfc-8729-be60cf66f1d7@kernel.dk>
Date: Tue, 8 Sep 2026 19:15:13 -0600
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6aa0876e.f81106d8.285f0a.0005.GAE@google.com>
 <31ab7ab6-2cf5-4fcb-a6cb-05fab461e742@kernel.dk>
Content-Language: en-US
In-Reply-To: <31ab7ab6-2cf5-4fcb-a6cb-05fab461e742@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git io_uring-7.3

Forgot to push it out... Let's kick it again.

-- 
Jens Axboe

