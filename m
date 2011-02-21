From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2 V2] e2fsprogs: enable user namespace xattrs by default
Date: Mon, 21 Feb 2011 11:00:34 -0600
Message-ID: <4D629A32.1030708@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com> <4D5D9981.1020300@redhat.com> <20110220233108.GB4001@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1BURAh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 12:00:37 -0500
In-Reply-To: <20110220233108.GB4001@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/20/11 5:31 PM, Ted Ts'o wrote:
> On Thu, Feb 17, 2011 at 03:56:17PM -0600, Eric Sandeen wrote:
>> User namespace xattrs are generally useful, and I think extN
>> is the only filesystem requiring a special mount option to
>> enable them, when xattrs are otherwise available.  So this
>> change sets that mount option into the defaults, via a
>> mke2fs.conf option.
>>
>> Note that if xattrs are config'd off, this will lead to a
>> mostly-harmless:
>>
>>    EXT4-fs (sdc1): (no)user_xattr options not supported
>>
>> message at mount time... 
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> You didn't run "make check" before submitting these patches.  Please
> do so in the future!  :-)
> 
> I'll fix up the expected test commit results for these two commits.
> 
>      	    		      	     	     - Ted

Argh sorry.  Out of practice I guess.

Thanks,
-Eric
