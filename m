From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][request for stable 3.10 inclusion] ext4 CVE-2014-8086
Date: Sat, 7 Feb 2015 16:54:04 +0800
Message-ID: <20150207085404.GB20290@kroah.com>
References: <54D31F09.4010401@huawei.com>
 <20150207085156.GA20290@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
	linux-ext4@vger.kernel.org, dmonakhov@openvz.org,
	sasha.levin@oracle.com, tytso@mit.edu
To: hujianyang <hujianyang@huawei.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150207085156.GA20290@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 07, 2015 at 04:51:56PM +0800, Greg KH wrote:
> On Thu, Feb 05, 2015 at 03:43:05PM +0800, hujianyang wrote:
> > Hi Greg,
> > 
> > The following patch commit a41537e69b4aa43f0fea02498c2595a81267383b
> > 
> > ext4: prevent bugon on race between write/fcntl
> > 
> > fix CVE-2014-8086 in upstream kernel. I wish you could merge this fix
> > into stable 3.10. Since refactoring in ext4, the sending patch is quite
> > different from the patch in upstream kernel.
> 
> Before I do that, can you also provide a backport to the 3.14-stable
> kernel tree so that we don't have that tree missing this?

Nevermind, I took this patch for 3.14 as your backport worked there as
well.

thanks,

greg k-h
