From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v4+ hot_track 16/19] btrfs: add hot tracking support
Date: Wed, 7 Nov 2012 01:00:25 +0100
Message-ID: <20121107000025.GY3102@twin.jikos.cz>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-17-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50719 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab2KGAAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 19:00:42 -0500
Content-Disposition: inline
In-Reply-To: <1351485061-12297-17-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30:58PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Introduce one new mount option '-o hot_track',
> and add its parsing support.
>   Its usage looks like:
>    mount -o hot_track
>    mount -o nouser,hot_track
>    mount -o nouser,hot_track,loop
>    mount -o hot_track,nouser
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
