Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2614726ED59;
	Fri,  6 Feb 2026 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770407590; cv=none; b=atQl2VPy8rQAlA1DTUMI2fPI4M7XLnvcs5fGWuqBIWBfBZe/+2vyY7zZ4U5CuOyijPv6fJMaO2o6+dUE3U3AX8l9a0MfwfLX7MctxGy9kMgV/vFphZ1YFWDM4SBSw2VYIIeNpP8HZjJIvMHiaAQgdvYBkB6Sk5vn8nWW7t2/jMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770407590; c=relaxed/simple;
	bh=lBlkB72HUvOQFuV0uVPFFGeGkIF0carnA0N3Sr9OGcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCYthRZAjmQFg1utqGm1S/MxKIMCkFZG/2WZ4xuD25QYj5Zh3SjT1VvnOD9BAAL/7uZd55j3PSG9X0oM02GxvoidHW01fP7Tngyg0NYVhrv72MRwWwH6SXe3lQ29iyGFQr8ZXy6p5Y8pMEIHReEF8VRr4CNTuePgI0gNtiEHZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APKc6cMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APKc6cMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE927C19422;
	Fri,  6 Feb 2026 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770407589;
	bh=lBlkB72HUvOQFuV0uVPFFGeGkIF0carnA0N3Sr9OGcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=APKc6cMw6j67oFsTD654c/iapJtc2tWGVClckylUlb98I02Cas4BMDNfPNuNpFGlE
	 AAtizw+MYZDJMCcoyPrlYozT32ADsVmOz2uYCX6jlbQsL7RLqfvCOxYzQqFBINMalm
	 /CqkYPg1YuPTpoTtj+gn5tPOjwCERcFJzjXfJ/RY/9r7kJNVqDGV+y+7qnHAv3iwkf
	 Ly9b645GgHJF1IgXD0SEvG2LFzE1RdwnNhrsWbM8EExu09zL0Ffr8rotlTDoJf+o+f
	 pEYxJvZO9slvcRnjvZIDxjKqEvBFKsGoXfarFBHTUsyqHQZcFIt8tM/rdICqYo7JI+
	 /7SbaE7qCbHdg==
Date: Fri, 6 Feb 2026 11:53:09 -0800
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, syzkaller@googlegroups.com,
	andy@kernel.org, akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in ext4_fill_super
Message-ID: <202602061152.EAAF56214@keescook>
References: <CAHPqNmzBb2LruMA6jymoHXQRsoiAKMFZ1wVEz8JcYKg4U6TBbw@mail.gmail.com>
 <aYX4n42gmy75aw4Y@smile.fi.intel.com>
 <aYYD3rxyIfdH2R-d@smile.fi.intel.com>
 <aYYE4iLTXZw5t0w_@smile.fi.intel.com>
 <202602061032.63DD1CA3AE@keescook>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602061032.63DD1CA3AE@keescook>

On Fri, Feb 06, 2026 at 11:29:11AM -0800, Kees Cook wrote:
> But I can't figure out where that comes from. Seems like fs_parse(), but
> I don't see where mount option strings would come through...

Oh! This is coming directly from disk. So we need an in-place sanity
check. How about this?


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d0..9ad6005615d8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2485,6 +2485,13 @@ static int parse_apply_sb_mount_options(struct super_block *sb,
 	if (!sbi->s_es->s_mount_opts[0])
 		return 0;
 
+	if (strnlen(sbi->s_es->s_mount_opts, sizeof(sbi->s_es->s_mount_opts)) ==
+	    sizeof(sbi->s_es->s_mount_opts)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Mount options in superblock are not NUL-terminated");
+		return -EINVAL;
+	}
+
 	if (strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts) < 0)
 		return -E2BIG;
 

-- 
Kees Cook
