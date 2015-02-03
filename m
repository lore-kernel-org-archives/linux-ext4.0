From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] ext4: fix warning in ext4_da_update_reserve_space()
Date: Tue, 03 Feb 2015 16:57:22 -0600
Message-ID: <54D15252.5000805@akamai.com>
References: <1420750108-11512-1-git-send-email-johunt@akamai.com> <20150203225343.GA3539@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	jack@suse.cz
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:64847 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbbBCW5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2015 17:57:24 -0500
In-Reply-To: <20150203225343.GA3539@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/03/2015 04:53 PM, Greg KH wrote:
> On Thu, Jan 08, 2015 at 03:48:28PM -0500, Josh Hunt wrote:
>>      Please add the patch below and referenced dependency (0e95c22) to stable
>>      3.10.y.
>
> There is no such commit "0e95c22" in Linus's tree, do you mean
> "1c8924eb106c1ac755d5d35ce9b3ff42e89e2511"?  If so, that doesn't apply
> to 3.10 at all, so I can't apply that on, and so, can't apply the patch
> below either :(
>
> Care to provide proper backports of both of them?
>
> thanks,
>
> greg k-h
>

Hey Greg

I thought we discussed this already. You've already applied these 
patches to 3.10.y:

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.10.y&id=23d5efc071f5f47257e5b33c41534a30b1099cc3

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.10.y&id=4e9eb2afbc494a56e35bf6c1a621f579eb1199b2

I messed up the commit id reference in my original submission to you, 
but sent a followup. Given that both patches are in 3.10.y now I don't 
think there's anything else to do.

Let me know if you need something else from me.

Thanks
Josh
