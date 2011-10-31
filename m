From: Ted Ts'o <tytso@mit.edu>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 16:00:53 -0400
Message-ID: <20111031200053.GI16825@thunk.org>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
 <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu>
 <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com>
 <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu>
 <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com>
 <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
 <4EAA2217.5020002@tao.ma>
 <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu>
 <4EAE780D.3090005@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58142 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab1JaUA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 16:00:57 -0400
Content-Disposition: inline
In-Reply-To: <4EAE780D.3090005@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 31, 2011 at 06:27:25PM +0800, Tao Ma wrote:
> In the new bigalloc case if chunk size=64k, and with the linux-3.0
> source, every file will be allocated a chunk, but they aren't contiguous
> if we only write the 1st 4k bytes. In this case, writeback and the block
> layer below can't merge all the requests sent by ext4. And in our test
> case, the total io will be around 20000. While with the cluster size, we
> have to zero the whole cluster. From the upper point of view. we have to
> write more bytes. But from the block layer, the write is contiguous and
> it can merge them to be a big one. In our test, it will only do around
> 2000 ios. So it helps the test case.

This is test case then where there are lot of sub-64k files, and so
the system administrator would be ill-advised to use a 64k bigalloc
cluster size in the first place.  So don't really consider that a
strong argument; in fact, if the block device is a SSD or a
thin-provisioned device with an allocation size smaller than the
cluster size, the behaviour you describe would in fact be detrimental,
not a benefit.

In the case of a hard drive where seeks are expensive relative to
small writes, this is something which we could do (zero out the whole
cluster) with the current bigalloc file system format.  I could
imagine trying to turn this on automatically with a hueristic, but
since we can't know the underlying allocation size of a
thin-provisioned block device, that would be tricky at best...

Regards,

		       	       	    	     - Ted
