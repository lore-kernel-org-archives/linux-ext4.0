From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: mke2fs options for large media archive filesystem
Date: Sun, 2 Feb 2014 18:30:13 -0700
Message-ID: <F3EDB2EF-E089-486A-B1FC-6395770B111E@dilger.ca>
References: <52EE703B.3010703@gmail.com> <op.xanxpcwg0ncgu9@vitalif.vhome>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Bastien Traverse <bastien.traverse@gmail.com>
To: Vitaliy Filippov <vitalif@yourcmc.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:42061 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaBCBg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Feb 2014 20:36:57 -0500
Received: by mail-ig0-f173.google.com with SMTP id c10so3278278igq.0
        for <linux-ext4@vger.kernel.org>; Sun, 02 Feb 2014 17:36:57 -0800 (PST)
In-Reply-To: <op.xanxpcwg0ncgu9@vitalif.vhome>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would say that bigalloc is probably not what you want for an archival system. It is relatively new and the space savings is minimal. It is mostly for filesystems that need to allocate and free large files rapidly. 

Note that with bigalloc you will also be allocating directories at the bigalloc cluster size? Which will be too large in most cases. 

Since you already know the average file size, using -i {average size} is what you want. The -N option is just a different way of specifying the same thing, the underlying filesystem ends up being the same.

I would also recommend to allocate about 2x the inodes you think you will need. If there are suddenly thumbnails of the photos or key photos for videos then you don't want to run out of inodes. 

Cheers, Andreas

> On Feb 2, 2014, at 9:35, "Vitaliy Filippov" <vitalif@yourcmc.ru> wrote:
> 
> Hi,
> 
>> b) bigalloc feature
> 
> As I understand (please correct me someone if I'm wrong), given that ext4 uses extents, bigalloc feature is really useful ONLY for minimizing block bitmaps. Which is probably only useful for (maybe) reducing kernel memory usage and for (maybe) reducing fragmentation. 'maybe' means I personally don't know if benefit will be large enough, and I even don't know if there would be any real benefit at all... I didn't see any real bigalloc tests in the web...
> 
> So, I personally don't think you'll really benefit from bigalloc on a 1TB archive partition... But I would like it very much if someone can tell an authoritative verdict. :)
> 
> -- 
> With best regards,
>  Vitaliy Filippov
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
