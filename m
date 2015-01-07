From: Josh Hunt <johunt@akamai.com>
Subject: Re: ext4_da_update_reserve_space warning fix not in stable
Date: Wed, 7 Jan 2015 14:16:34 -0600
Message-ID: <54AD9422.2050803@akamai.com>
References: <54AD772B.2050003@akamai.com> <20150107195324.GN7291@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"jack@suse.cz" <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:40749 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082AbbAGUQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2015 15:16:43 -0500
In-Reply-To: <20150107195324.GN7291@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 01/07/2015 01:53 PM, Theodore Ts'o wrote:
> On Wed, Jan 07, 2015 at 12:12:59PM -0600, Josh Hunt wrote:
>> We are hitting the following warning in the field pretty frequently on the
>> latest 3.10 stable kernel:
>> [11708.763067] WARNING: at fs/ext4/inode.c:363
>> ext4_da_update_reserve_space+0x261/0x280 [ext4]()
>>
>> The issue was resolved via "ext4: fix warning in
>> ext4_da_update_reserve_space()" (7d7345322d60ed), but the fix was not
>> submitted as a stable update for 3.10. I was wondering if there's a reason
>> why this was not done, or if it was just overlooked?
>>
>> The patch appears to have a dependency on "quota: provide interface for
>> readding allocated space into reserved space" (1c8924eb106c1ac), so I think
>> both would need to be submitted if you feel it's possible.
>
> Have you tried backporting these two commits, and does it fix the
> problem for you?

Yeah I backported both. They both apply cleanly to 3.10 iirc. I will 
report back if they do not.

Yes, moving both of these to 3.10 fixes the problem for me.

>
> I think it was mostly an oversight, although it might have also been
> my thinking that it was only a warning, so it wasn't that critical to
> backport.  To be honest, I can't really recall exactly what happened
> with that patch at this point.
>
> If it does seen to work for you, I'm happy to suggest to the 3.10
> stable kernel maintainers to have it be backported.

That would be great, thanks!

Josh
