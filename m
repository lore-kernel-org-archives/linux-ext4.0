From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH V3 01/21] ext4: Move extra inode read to a new function.
Date: Mon, 19 Dec 2011 09:32:41 +0100
Message-ID: <BB5BC380-D840-4AD8-80CC-C320AF780FEF@whamcloud.com>
References: <4EEDF6B1.7050206@tao.ma> <1324218278-2460-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"adilger@dilger.ca" <adilger@dilger.ca>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35638 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1LSLRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 06:17:38 -0500
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-18, at 15:24, Tao Ma <tm@tao.ma> wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, in ext4_iget we do a simple check to see whether
> there does exist some information starting from the end
> of i_extra_size. With inline data added, this procedure
> is more complicated. So move it to a new function named
> ext4_iget_extra_inode.
> 
> +        } else
> +            ext4_iget_extra_inode(inode, raw_inode, ei);
>    } else

(style) if one half of an if-else uses braces then the other half should as well. 

Cheers, Andreas
