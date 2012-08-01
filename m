From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Wed, 1 Aug 2012 15:48:46 +0800
Message-ID: <20120801074845.GA13030@gmail.com>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
 <20120801071935.GA12929@gmail.com>
 <5018D7D9.6080709@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: semenko@syndetics.net, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, tytso@mit.edu, djwong@us.ibm.com
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2HAHkC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 03:40:02 -0400
Received: by pbbrp8 with SMTP id rp8so675352pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2012 00:40:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5018D7D9.6080709@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 02:16:41PM +0700, Tomasz Chmielewski wrote:
> On 08/01/2012 02:19 PM, Zheng Liu wrote:
> > Hi Nick and Tomasz,
> > 
> > Could you please try this patch?  It seems that the problem is because
> > error code doesn't be clear.
> 
> Hi,
> 
> didn't try the patch yet, but I've noticed the following in dmesg since 3.5:
> 
> [69004.637293] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> [69004.637330] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
> [69004.637335] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> [69004.637365] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
> [69004.637370] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> 
> 
> Could this be related?

Are these messages printed before you enable metadata_csum feature?

Regards,
Zheng
