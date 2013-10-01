From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 08/11] ext4: Fix end of group handling in
 ext4_mb_init_cache
Date: Tue, 1 Oct 2013 16:20:31 +0200
Message-ID: <20131001142031.GG6931@two.firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-9-git-send-email-andi@firstfloor.org>
 <20131001124541.GB2097@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131001124541.GB2097@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> What's this change all about, and why is it included in this
> patch?

Sorry that was me fat-fingering git add. Ignore that hunk.

I needed it for the static analyzer, which does not understand asm goto.

-Andi
