From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: remove duplicated encryption mode
 definitions
Date: Sat, 2 May 2015 10:26:36 -0400
Message-ID: <20150502142636.GD10014@thunk.org>
References: <1429779376-26355-1-git-send-email-chanho61.park@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chanho Park <chanho61.park@samsung.com>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Chanho Park <parkch98@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429779376-26355-1-git-send-email-chanho61.park@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 23, 2015 at 05:56:16PM +0900, Chanho Park wrote:
> This patch removes duplicated encryption modes which were already in
> ext4.h. They were duplicated from commit 3edc18d and commit f542fb.

Thanks, applied.

					- Ted
