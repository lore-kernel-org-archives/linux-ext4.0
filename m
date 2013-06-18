From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4:an improvement in ext4 feature inline_data
Date: Tue, 18 Jun 2013 11:21:01 -0400
Message-ID: <20130618152101.GD7359@thunk.org>
References: <CAAFszuV7QJc2-5xFerStUrjNhD4+MR3R7kBVAxsg+Otx18RvGg@mail.gmail.com>
 <51A210D9.3030703@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boxi liu <boxi10liu@gmail.com>, Robin Dong <sanbai@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59039 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab3FRPVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:21:23 -0400
Content-Disposition: inline
In-Reply-To: <51A210D9.3030703@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 26, 2013 at 09:40:41PM +0800, Tao Ma wrote:
> On 05/26/2013 09:19 PM, boxi liu wrote:
> > In ext4 feature inline_data,it use the xattr's space to store the
> > inline data in inode.When we calculate the inline data as the xattr,we
> > add the pad.But in get_max_inline_xattr_value_size() function we count
> > the free space without pad.It cause some contents are moved to a block
> > even if it can be
> > stored in the inode.
> > 
> > Signed-off-by:liulei <lewis.liulei@huawei.com>
> Reviewed-by: Tao Ma <boyu.mt@taobao.com>

Applied, thanks.

					- Ted
