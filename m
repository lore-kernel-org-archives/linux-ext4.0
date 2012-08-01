From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Wed, 01 Aug 2012 14:16:41 +0700
Message-ID: <5018D7D9.6080709@wpkg.org>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com> <20120801071935.GA12929@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: semenko@syndetics.net, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, tytso@mit.edu, djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:43011 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab2HAHQt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 03:16:49 -0400
In-Reply-To: <20120801071935.GA12929@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/01/2012 02:19 PM, Zheng Liu wrote:
> Hi Nick and Tomasz,
> 
> Could you please try this patch?  It seems that the problem is because
> error code doesn't be clear.

Hi,

didn't try the patch yet, but I've noticed the following in dmesg since 3.5:

[69004.637293] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
[69004.637330] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
[69004.637335] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
[69004.637365] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
[69004.637370] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.


Could this be related?

-- 
Tomasz Chmielewski
http://blog.wpkg.org

