From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: remove duplicate header file
Date: Tue, 28 Jul 2015 15:13:30 -0400
Message-ID: <20150728191330.GO2851@thunk.org>
References: <1437033521-3138-1-git-send-email-liuziloong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, mhalcrow@google.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: liuziloong@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437033521-3138-1-git-send-email-liuziloong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 16, 2015 at 03:58:41PM +0800, liuziloong@gmail.com wrote:
> From: "zilong.liu" <liuziloong@gmail.com>
> 
> Remove key.h which is included twice in crypto_fname.c
> 
> Signed-off-by: zilong.liu <liuziloong@gmail.com>

Applied, thanks.

					- Ted
