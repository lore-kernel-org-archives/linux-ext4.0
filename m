From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4/mballoc: Remove unneeded variable "err"
Date: Sun, 5 Aug 2018 10:49:02 -0400
Message-ID: <20180805144902.GB26138@thunk.org>
References: <1533380696-16325-1-git-send-email-zhongjiang@huawei.com>
 <20180804212426.GE4461@thunk.org>
 <5B66F4B5.8030908@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B66F4B5.8030908@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 05, 2018 at 08:59:33PM +0800, zhong jiang wrote:
>  I create the diff in this patch again ,but get the same result .
>  the git version is git version 1.7.12.4 but I create the diff in
>  git version 1.8.3.1. It shows the correct function name.

Ah, OK, so it was a git bug.  Whew!  Glad to have that mystery solved.  :-)

        	      	    	      	     - Ted
