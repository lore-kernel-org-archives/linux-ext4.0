From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] avoid NULL deference in ext2_xattr_get
Date: Sat, 10 Jul 2010 11:21:52 +0200
Message-ID: <20100710092151.GS19184@bicker>
References: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: shenghui <crosslonelyover@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Another way to fix this would be to say:

   	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
-  		  name_index, name, buffer, (long)buffer_size);
+  		  name_index, name ?: "(null)", buffer, (long)buffer_size);

That would help for debugging.

regards,
dan carpenter
