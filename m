From: Theodore Tso <tytso@mit.edu>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of
	device, freeing blocks not in datazone
Date: Wed, 21 May 2008 07:38:55 -0400
Message-ID: <20080521113855.GD8581@mit.edu>
References: <4832941A.70806@tuxes.nl> <20080520123505.GP15035@mit.edu> <48334A82.6020508@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56699 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756462AbYEULjP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 07:39:15 -0400
Content-Disposition: inline
In-Reply-To: <48334A82.6020508@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2008 at 12:02:42AM +0200, Bas van Schaik wrote:
> Ah, such a lead was exactly what I was looking for, now I at least know
> where those bogus numbers were coming from. Maybe a very dump question:
> you seem to have reverse the ascii "translation", why? 

x86 (and the ext3 indirect blocks) are stored in little endian format.
If you doubt me, try running this program:

main(int argc, char **argv)
{
	char	a[5];
	int	*b;

	b = (int *) a;
	*b = 0x61626364;
	a[4] = 0;
	printf("%s\n", a);
}

> Summarizing all this: there is clearly something writing garbage to the
> wrong place. It must be something above the encryption layer, since
> that's the only way ascii can be written to the device.
> 
> Remember the different layers:
>   ext3 on decrypted /dev/loop0
>   LVM logical volume (encrypted)
>   RAID5 arrays
>   Imported AoE-devices
>   Physical disks
> 
> This conclusion kind of worries me, I was assuming that there was
> something wrong at the networking level (AoE) or below. If that were the
> case, the encrypted data would get modified and the corruptions would
> look totally different. Or am I missing something?

Not necessarily, this could be simply valid data getting written to
the wrong place.  

How are you encrypting your loop device, and what encryption system
are you using?

What sort of workload are you using with your filesystem, what version
of the kernel are your running, and does the machine crash often
(i.e., forcing journal replays)?

							- Ted
