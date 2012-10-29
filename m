From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC v4+ hot_track 13/19] debugfs: introduce one function
Date: Mon, 29 Oct 2012 11:11:35 -0700
Message-ID: <20121029181135.GB3605@kroah.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 29, 2012 at 12:30:55PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   The debugfs function is used to get expected dentry.

Huh?  Why do you need this?  Why haven't you added documentation for the
function saying what it does?

confused,

greg k-h
