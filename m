From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V1 00/17] ext4: Add inline data support.
Date: Wed, 26 Oct 2011 16:17:01 +0800
Message-ID: <4EA7C1FD.3090907@tao.ma>
References: <4EA7B788.3040503@tao.ma> <CAOQ4uxgpkd5WwwwkuxTupYRS-2Nf7mu=V5JCO2CTYQN3k0BCCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42361 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754608Ab1JZIRK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 04:17:10 -0400
In-Reply-To: <CAOQ4uxgpkd5WwwwkuxTupYRS-2Nf7mu=V5JCO2CTYQN3k0BCCg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/2011 04:05 PM, Amir Goldstein wrote:
> 
> 
> On Wed, Oct 26, 2011 at 9:32 AM, Tao Ma <tm@tao.ma <mailto:tm@tao.ma>>
> wrote:
> 
>     Hi Ted, Andreas and list,
>            This is my 1st attempt to add inline data support to ext4
>     inode. For
>     more information about the background, please refer to the thread
>     http://marc.info/?l=linux-ext4&m=131715205428067&w=2
>     <http://marc.info/?l=linux-ext4&m=131715205428067&w=2>
>     When I sent out the RFC on Sep.27, Andreas suggested that we can use the
>     space of xattr to put inline data. So this is the 1st version using that
>     method. It should be easy to change if we decide to use other places in
>     inode(e.g the unused extent space) since all the inline data
>     manipulation function is wrapped with function like ext4_*_inline_data.
> 
>     Currently I use all the space between i_extra_isize and inode_size if
>     inode_size = 256. For inode_size > 256, half of that space is used so as
>     to leave some space for other xattrs.
> 
>     This is only a V1 and there are still something to do(e.g. I am thinking
>     of using unused extent space), but I'd like to send it out earlier so
>     that it can be reviewed ASAP.
> 
>     Some simple tests shows that with a linux-3.0 vanilla source, the new
>     dir can save 1% disk space. For my "/usr", it can save about 3.2%
>     spaces. I guess for volume with future bigalloc support, it should save
>     more space for us for small dir. I also run some other tests and it
>     seems the code is OK for a try. I haven't found a good test cases that
>     can test the small file/dir(tens of bytes in my case) performance where
>     inline data should have some good number.
> 
>     Any comments are welcomed.
> 
>     git diff --stat
> 
>     fs/ext4/dir.c    |  117 ++++++++++-
>     fs/ext4/ext4.h   |   15 +-
>     fs/ext4/ialloc.c |    4 +
>     fs/ext4/inode.c  |  583
>     +++++++++++++++++++++++++++++++++++++++++++++++---
> 
> 
> Hi Tao,
> 
> One generic comment.
> how about adding a new file fs/ext4/inline.c to host inline data support
> related code?
> inode.c is too big as it is and there is an effort the size it down.
sure, I will try to separate related functions to inline.c in my V2.

Thanks
Tao
