From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Wed, 1 Aug 2012 16:17:44 +0800
Message-ID: <20120801081744.GA13335@gmail.com>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
 <20120801071935.GA12929@gmail.com>
 <5018D7D9.6080709@wpkg.org>
 <20120801074845.GA13030@gmail.com>
 <5018E00F.1000207@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: semenko@syndetics.net, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, tytso@mit.edu, djwong@us.ibm.com
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39080 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2HAIJB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 04:09:01 -0400
Received: by pbbrp8 with SMTP id rp8so711985pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2012 01:09:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5018E00F.1000207@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 02:51:43PM +0700, Tomasz Chmielewski wrote:
> On 08/01/2012 02:48 PM, Zheng Liu wrote:
> 
> >>didn't try the patch yet, but I've noticed the following in dmesg since 3.5:
> >>
> >>[69004.637293] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> >>[69004.637330] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
> >>[69004.637335] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> >>[69004.637365] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
> >>[69004.637370] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
> >>
> >>
> >>Could this be related?
> >
> >Are these messages printed before you enable metadata_csum feature?
> 
> I didn't notice them before trying to enable metadata_csum feature.
> 
> On the other hand, enabling metadata_csum feature was pretty much
> the first thing I've made after booting to 3.5 kernel on this
> system, so it could be it changed something.

Yes, it will change something when you try to enable metadata_csum
feature in tune2fs.  So you'd better to run e2fsck to check your
filesystem IMHO.

> 
> 
> Also, when I do:
> 
> 	dumpe2fs -h /dev/sda1|grep metadata_csum
> 
> I don't see metadata_csum feature anywhere.

You won't see this feature until you can enable this feature successful.

Regards,
Zheng
