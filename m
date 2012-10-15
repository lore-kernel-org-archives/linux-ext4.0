From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC v3 13/13] vfs: add documentation
Date: Mon, 15 Oct 2012 08:35:27 +0800
Message-ID: <20121015003527.GA23324@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-14-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:34493 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2JOAY3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2012 20:24:29 -0400
Content-Disposition: inline
In-Reply-To: <1349863655-29320-14-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zhi Yong,

[cut...]
> +3. The Design
> +
> +These include the following parts:
> +
> +    * Hooks in existing vfs functions to track data access frequency
> +
> +    * New rbtrees for tracking access frequency of inodes and sub-file
             ^^^^^^^ s/rbtrees/radix-trees
> +ranges (hot_rb.c)
           ^^^^^^^^ Now it seems that all codes are in the same file.

Regards,
Zheng
