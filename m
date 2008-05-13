From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Tue, 13 May 2008 07:48:49 -0500
Message-ID: <48298E31.7050205@redhat.com>
References: <4827B878.50903@oracle.com> <4828DE73.2070001@redhat.com> <482947C3.9040601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tiger Yang <tiger.yang@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <482947C3.9040601@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tiger Yang wrote:
> Hi, Eric,
> 
> I don't have tesecase about this bug. I did the test manually. I use 
> khexedit to confirm the attributes whether in inody or block.
> The problem about this bug is we want to replace an existing attribute 
> in ibody with big size value which larger than free space in ibody.
> Because we didn't do block_find(), so the struct bs have not been 
> initialized. Then when we try to set attribute in block by block_set(), 
> we find bs->base is empty, we need alloc a new block for attributes. The 
> old block pointed by i_file_acl will lost with attributes in it.

Thanks, I'll go for a reproducer.  We use xattrs a lot for selinux in
Red Hat and Fedora, so a little surprised I haven't seen this bug... or
maybe it explains some bugs I haven't yet figured out ... :)

Thanks,
-Eric
