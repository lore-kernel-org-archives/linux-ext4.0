From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH]: e2fsprogs m_* self tests no longer pass
Date: Wed, 16 Mar 2011 03:17:32 -0600
Message-ID: <D3ADD1DC-674F-4EFB-A82C-9C331F2830BA@whamcloud.com>
References: <AANLkTikX2u+tz7e39tb8abRuXtiLDusKpjAf9vZ1tYUU@mail.gmail.com> <alpine.LFD.2.00.1103011046240.3874@dhcp-27-109.brq.redhat.com> <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com> <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com> <alpine.LFD.2.00.1103160910520.21429@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bruce Cassidy <bruce@whamcloud.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62371 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1CPJRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 05:17:36 -0400
Received: by yia27 with SMTP id 27so573941yia.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 02:17:35 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1103160910520.21429@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-16, at 2:14 AM, Lukas Czerner wrote:
> On Tue, 15 Mar 2011, Andreas Dilger wrote:
>> Only display the "Discarding device blocks:" status bar if discard is actually implemented in the IO manager and in the kernel.  Otherwise, there is no correct test result that will work in all environments.  I'd prefer not to print an error message for the majority of devices that do not support discard, since this is confusing.
>> 
>> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> 
> Hi Andreas,
> 
> thanks for the patch, it looks good, I have almost the same one in my tree
> :). I was wondering if we have any way to tell if the device support discard
> or not from the user-space, I did not found any reliable way (other than
> actually call BLKDISCARD and see).

I was originally going to add a CHANNEL_FLAGS_DISCARD flag to the iomanager, but just setting this if BLKDISCARD is defined does not determine if the kernel or disk device has support for TRIM/UNMAP.  Since the only way to check this AFAICS is to call BLKDISCARD I changed the code as seen in the patch.

It wouldn't be terrible to set or clear the CHANNEL_FLAGS_DISCARD flag for a device depending on whether io_channel_discard() succeeds, but I suspect there will be few cases where discard is called multiple times on the same device.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



