From: Yaowei Bai <bywxiaobai@163.com>
Subject: Re: [PATCH 07/17] fs/ext4: remove unnecessary new_valid_dev check
Date: Fri, 30 Oct 2015 09:38:55 +0800
Message-ID: <20151030013855.GA25809@localhost.localdomain>
References: <1443446807-4838-1-git-send-email-bywxiaobai@163.com>
 <1443448237-5285-1-git-send-email-bywxiaobai@163.com>
 <20151029180901.GA29914@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org
To: Theodore Ts'o <tytso@mit.edu>, viro@zeniv.linux.org.uk,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151029180901.GA29914@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 29, 2015 at 02:09:01PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 28, 2015 at 09:50:37PM +0800, Yaowei Bai wrote:
> > As new_valid_dev always returns 1, so !new_valid_dev check is not
> > needed, remove it.
> > 
> > Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
> 
> Thanks, applied.

Ted, this patch has been merged into andrew's mm tree.

> 
> 					- Ted
