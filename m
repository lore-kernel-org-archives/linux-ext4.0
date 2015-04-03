From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove useless condition in if statement.
Date: Thu, 2 Apr 2015 23:51:26 -0400
Message-ID: <20150403035126.GF10991@thunk.org>
References: <1426555914-731-1-git-send-email-weiyuan.wei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wei Yuan <weiyuan.wei@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426555914-731-1-git-send-email-weiyuan.wei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 17, 2015 at 09:31:54AM +0800, Wei Yuan wrote:
> In this if statement, the previous condition is useless, the later one has covered it.
> 
> Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>

Applied, thanks.

					- Ted
