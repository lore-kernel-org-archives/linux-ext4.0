From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Wed, 4 Jul 2012 21:25:20 +0800
Message-ID: <20120704132519.GA4301@gmail.com>
References: <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <4FF39924.7070602@ubuntu.com>
 <20120704023634.GB16947@gmail.com>
 <4FF3B352.3040707@ubuntu.com>
 <4FF434F7.2070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GDNRI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2012 09:17:08 -0400
Received: by pbbrp8 with SMTP id rp8so11029141pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jul 2012 06:17:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FF434F7.2070906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 04, 2012 at 08:20:07AM -0400, Ric Wheeler wrote:
> On 07/03/2012 11:06 PM, Phillip Susi wrote:
> For reasonably sized files, you might just as well really write out
> the full file with "write" (do pre-allocation the old fashioned
> way).
> 
> Performance of course depends on the size of the file, but for a 1GB
> file you can do this in a few seconds and prevent fragmentation and
> totally eliminate the performance of flipping extents.
> 
> How large is the file you need to pre-allocate? How long does the
> job typically run (minutes? hours? days?) :)

We have over one thousand servers with ten or more 2T SATA disks, and we
need to pre-allocate a lot of files with fixed size until the space of
every disks is occupied when the application starts up on first time.
Meanwhile this number is increasing every months.  It will be absolutely
a nightmare for SA if we use the old fashioned way to do pre-allocation.

Regards,
Zheng
