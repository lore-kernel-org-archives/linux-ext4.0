From: Michael Burschik <Michael.Burschik@gmx.de>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 08:19:16 +0200
Message-ID: <452F2FE4.4010401@gmx.de>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:18092 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751115AbWJMGS6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 02:18:58 -0400
To: linux-ext4@vger.kernel.org
In-Reply-To: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> Storing the tail as an extended attribute
> =========================================
>
> Stephen and I have discussed this in the past, and the idea is a simple
> one; simply store the tail as an extended attribute.  There are other
> filesystems that have done this, most notably NTFS (post-Windows 2000).
> However, this approach is a little unsatisfying to me, since it buys us
> nothing if there are no other extended attributes contained by the
> filesystem, and if we are using large inodes to accelerate extended
> attributes, there won't be much space for any but the smallest tails
> (i.e., if we are using 4k blocks, and 512 byte inodes, the largest tail
> that we could store using this method is around 350 bytes or so.)
>
> Using this technique would only require a flag in the inode indicating
> it has a fragment, so the filesystem knows to look for the extended
> attribute.  In theory this could also be done by checking the i_size
> field, and assuming that last block in the file can never normally be a
> hole, but this can be quite fragile.
>
>   
Disclaimer: I am not a file system expert.

That said, I still think there are some advantages to this scheme. First 
of all, 350 bytes are not all that bad. Many short files are 
configuration files, and many of them are shorter than 350 bytes 
(resolv.conf, hostname, hosts, etc.). On my system I find more than 300 
files shorter than 512 bytes in /etc, and more than 700 in my home 
directory. Some applications read many configuration files, so I would 
expect this scheme to lead to a considerable speed improvement. 
Moreover, there is much to be said in favour of configuration systems 
that store exactly one value per file, such as tcb and Elektra.

Secondly, I expect systems that do not use extended attributes to become 
increasingly rare. SELinux has become mainstream. It is included in Red 
Hat/Fedora, Ubuntu, Debian etch (IIRC). Desktop software such as Beagle 
uses extended attributes if available, and I expect this tendency to 
increase. Desktop software is also notorious for needing vast numbers of 
configuration files.

Regards

Michael Burschik
