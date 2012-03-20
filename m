From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 09:03:25 -0400
Message-ID: <20120320130325.GG14363@thunk.org>
References: <20120320025835.GE14363@thunk.org>
 <1332212574.7847.49.camel@joe2Laptop>
 <216818.1332222366@turing-police.cc.vt.edu>
 <20120320.031001.1532841232287663716.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valdis.Kletnieks@vt.edu, joe@perches.com, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120320.031001.1532841232287663716.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 20, 2012 at 03:10:01AM -0400, David Miller wrote:
> > OK. Say I'm a scraper.  How do I distinguish between:
> > 
> > pr_info("foo");
> > printk(KERN_INFO "foo");
> > 
> > Oh my. seems that both result in exactly the same thing ending up in the
> > dmesg buffer
> 
> No it doesn't result in the same output, read the definitions again.
> 
> pr_info can be influenced by pr_fmt, plain printk cannot

But if you don't use pr_fmt, it's the same.  And even if you do, then
pr_info() is the same as printk(KERN_INFO pr_fmt ...).  For a device
driver where cut and paste reuse happens, sure, it's handy.  But for
the rest of the kernel, it doesn't really buy you anything.  

And as I've said, something like ext4_msg(sb, ...) is **far** more
useful.  I don't need a 1200-line patch that messes with debug
printk's that are #ifdef'ed out.

     	   	     	  	       	       - Ted
