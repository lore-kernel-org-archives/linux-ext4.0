Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C3617A2E8
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028476; cv=none; b=P3Rd+vJ/ssbGOXbfubL2wFFxYQbNiBkVSRekGTWqnmPsCxh2Fl9rEQCQS63jRgOc75vbgdS5L/4pJshwxuUVOIVa/7hXQb2Spd8upQ+bvwEP8t7gxRCze+OTw0gf78h4yMiWwQJMWQ3iwAE7SJPXVqm0UkOvip1pNb8Wyi5wtCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028476; c=relaxed/simple;
	bh=U0bpE99PUh8qV0A+UOxxtnXX10N4sEZ8jIFV6xzZAEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ax3WvANteJgB/IxwpZN0GVpYDH8Mx+DHAgcZvpysA/8PbjKsC+w3jogCt+9oCOMd6bvqaPoYINUUDZuj0POHUHMmfIMb6p80mZ7hbt2CYbNcP1tEFjOinzlR2evLyD8YPIt6jgwz/o/sYGI9I4HCFvvbwoxj+4U4lVGXKHI2sqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=YOT8wXNf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="YOT8wXNf"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676F16UW011297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 11:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786028468; bh=6wCtX86zAOJS2frXZ+i+8FcR0fVNEGfpsORYohK7zZA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=YOT8wXNf4O6t7oQ54WGVBY+UCGWG13w66KKEMBdQHDcI+9JdpIUcuhlV82jIUl0vp
	 RNOnBmBhVcOwSPosQtvtUUMLen7/2lpYPtFjVG4TI3WDxbmCNIl+sMfddZZd5d8DPu
	 gyyQcbhC5By6akJ2/O90PWOkbKFbNwafOz99xApYNwEOz4zv1LQs0tvR65FMI9GbZt
	 n9d+BYoQDKWSzAbrX0cXZPqTEd4FSpVI7sdNpOjPFOBqAvu/SYLFkajm42pfedey0w
	 uEQNjeqg6yLjhKMOxbMRtKPghOMcmCTSydZMYbZjio/9gA1z5A6GXR6xELHCeQK1cS
	 9D+Dn4SP15DeQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 121072E3F17; Thu, 06 Aug 2026 11:01:06 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>, Junzhe Yu <junzheyu1@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: guard against NULL s_group_info in ext4_get_group_info
Date: Thu,  6 Aug 2026 11:00:59 -0400
Message-ID: <178602814516.965683.9213635677303390917.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <65c955b0-716b-4599-b925-59c2782e38b4@gmail.com>
References: <65c955b0-716b-4599-b925-59c2782e38b4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 04 Aug 2026 12:55:33 +0800, Junzhe Yu wrote:
> Resend: previous attempt was rejected by vger for containing HTML.
> 
> ==================================================================
> 
> ext4_mark_group_bitmap_corrupted() already treats a NULL return from
> ext4_get_group_info() as "nothing to do", but ext4_get_group_info()
> indexes s_group_info without checking whether the array exists.
> 
> [...]

Applied, thanks!

[1/1] ext4: guard against NULL s_group_info in ext4_get_group_info
      commit: 8f3901fbb40745046e513226ad84e8b84492632d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
