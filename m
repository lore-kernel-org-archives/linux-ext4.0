From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto devices
Date: Fri, 07 Mar 2008 15:20:37 +0100
Message-ID: <n7xiqzywr7u.fsf@sor.suse.de>
References: <n7xejaoynp9.fsf@sor.suse.de>
	<1204813967.8679.28.camel@norville.austin.ibm.com>
	<n7xzltbwzq3.fsf@sor.suse.de>
	<1204824227.7964.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYCGOUk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 09:20:40 -0500
In-Reply-To: <1204824227.7964.4.camel@norville.austin.ibm.com> (Dave
	Kleikamp's message of "Thu\, 06 Mar 2008 11\:23\:47 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> On Thu, 2008-03-06 at 18:04 +0100, Matthias Koenig wrote:
>> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
>
>> > Should field 8 of /etc/fstab (fs_passno) be zero for these mount points?
>> > Is there any reason for it to be anything different?
>> 
>> Why? zero would mean that they should never get checked.
>> I think it is reasonable to have the choice to get your crypto
>> filesystems checked. Current practise for SuSE has been to allow
>> only 0, but checked this filesystem anyway, which has lead to complaints.
>> So we want to do this more consistent.
>
> Zero tells fsck not to check the filesystem during reboot.  It's what
> tells fsck -A which filesystems to check.  If we don't expect the
> filesystem to be check-able during that phase, a non-zero value won't
> have any real meaning.

I see, but what are we doing with crypto filesystems for which the devices
simply do not exist at this phase in the boot process?
How should we specify that we want these filesystems to be checked or not 
at a later time in the boot process after the crypto devices have been
set up? 

Matthias
