From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Mon, 12 May 2008 19:18:59 -0500
Message-ID: <4828DE73.2070001@redhat.com>
References: <4827B878.50903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tiger Yang <tiger.yang@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757316AbYEMAT2@vger.kernel.org>
In-Reply-To: <4827B878.50903@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tiger Yang wrote:
> Hi,
> I met a bug when I try to replace a xattr entry in ibody with a big size 
> value. But in ibody there has no space for the new value. So it should 
> set new xattr entry in block and remove the old xattr entry in ibody.
> 
> Best regards,
> tiger
> 

Tiger, do you have a testcase handy to demonstrate this?

Is the new, large out-of-inode xattr unique so that it does not match
any existing attribute block, I assume?

Thanks,

-Eric
