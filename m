From: Sandon Van Ness <sandon@van-ness.com>
Subject: Re: ext4 df free space reporting not reliable?
Date: Sun, 13 Jun 2010 09:45:35 -0700
Message-ID: <4C150B2F.7040208@van-ness.com>
References: <20100613093807.GA31407@basil.fritz.box> <69DFE925-D32D-4CAA-B734-545DE0515FCE@mit.edu> <20100613103451.GF31464@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from box.houkouonchi.jp ([208.97.140.21]:53702 "EHLO
	box.houkouonchi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab0FMQpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jun 2010 12:45:52 -0400
In-Reply-To: <20100613103451.GF31464@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/13/2010 03:34 AM, Andi Kleen wrote:
>> Are you creating the files as root?  Sounds like the standard reserved
>> blocks behavior that's been around since ext3, ext2, BSD's ufs, etc...
>>     
> Yes everything is root.
>
> I would expect root df to not report the reservation. Is that not the case?
>
> -Andi
>   

Is the root reserve (default 5% on ext3, not sure for ext3) set to 0?

tune2fs -m0 /dev/sdX

The file-system does not need to be unmounted to do this but this will
change the amount reported as available as once it hits 0 with the root
reserve only root can write to the FS.
