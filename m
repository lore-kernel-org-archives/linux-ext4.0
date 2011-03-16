From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH]: e2fsprogs m_* self tests no longer pass
Date: Wed, 16 Mar 2011 09:14:53 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103160910520.21429@dhcp-27-109.brq.redhat.com>
References: <AANLkTikX2u+tz7e39tb8abRuXtiLDusKpjAf9vZ1tYUU@mail.gmail.com> <alpine.LFD.2.00.1103011046240.3874@dhcp-27-109.brq.redhat.com> <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com> <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bruce Cassidy <bruce@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1CPIO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 04:14:58 -0400
In-Reply-To: <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 15 Mar 2011, Andreas Dilger wrote:

> Only display the "Discarding device blocks:" status bar if discard is actually implemented in the IO manager and in the kernel.  Otherwise, there is no correct test result that will work in all environments.  I'd prefer not to print an error message for the majority of devices that do not support discard, since this is confusing.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> 
> 

Hi Andreas,

thanks for the patch, it looks good, I have almost the same one in my tree
:). I was wondering if we have any way to tell if the device support discard
or not from the user-space, I did not found any reliable way (other than
actually call BLKDISCARD and see).

Thanks!
