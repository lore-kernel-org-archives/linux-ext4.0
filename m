From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] vfs: introduce helper function to safely NUL-terminate symlinks
Date: Fri, 19 Dec 2008 15:03:52 +0000
Message-ID: <e9e943910812190703w6fb43cebmfe96f2a2e8cc47dd@mail.gmail.com>
References: <1229442720-31056-3-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-4-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-5-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-1-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-6-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
	 <20081216234638.GX5000@webber.adilger.int>
	 <e9e943910812161626i6f2cdc3eldc36c68e9a98f180@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Andreas Dilger" <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Al Viro" <viro@zeniv.linux.org.uk>,
	"Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <e9e943910812161626i6f2cdc3eldc36c68e9a98f180@mail.gmail.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2008/12/17 Duane Griffin <duaneg@dghda.com>:
> It is true for sysv, too. The ufs code also, but that has other
> issues, anyway. The generic page symlink and freevxfs patches should
> be fine, though.

Before I fire off another set of patches, should I be sending out the
complete set again or just the ones that need to be updated?

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
