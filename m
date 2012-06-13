From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] E2fsprogs: add missing usage for No_COW
Date: Wed, 13 Jun 2012 15:44:55 -0400
Message-ID: <20120613194455.GA17990@thunk.org>
References: <1339577802-31343-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	rm@romanrm.ru
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1339577802-31343-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 13, 2012 at 04:56:42PM +0800, Liu Bo wrote:
> Add the missing usage for No_COW since we've supported No_COW flag.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Applied, although I changed the commit desciption to read:

    chattr: add the -C option to the usage message

    	    	       	      	     - Ted
