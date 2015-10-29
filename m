From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/17] fs/ext4: remove unnecessary new_valid_dev check
Date: Thu, 29 Oct 2015 14:09:01 -0400
Message-ID: <20151029180901.GA29914@thunk.org>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
 <1443448237-5285-1-git-send-email-bywxiaobai@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Yaowei Bai <bywxiaobai@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443448237-5285-1-git-send-email-bywxiaobai@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 28, 2015 at 09:50:37PM +0800, Yaowei Bai wrote:
> As new_valid_dev always returns 1, so !new_valid_dev check is not
> needed, remove it.
> 
> Signed-off-by: Yaowei Bai <bywxiaobai@163.com>

Thanks, applied.

					- Ted
