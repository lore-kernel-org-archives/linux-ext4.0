From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Wed, 28 Nov 2012 23:49:16 -0600
Message-ID: <50B6F75C.8070903@redhat.com>
References: <50A546D8.3020500@redhat.com> <20121129044609.GC8029@thunk.org> <20121129045230.GD8029@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2K2FtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 00:49:19 -0500
In-Reply-To: <20121129045230.GD8029@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/28/12 10:52 PM, Theodore Ts'o wrote:
> On Wed, Nov 28, 2012 at 11:46:10PM -0500, Theodore Ts'o wrote:
>>
>> And I did come up with a test case...
>>
> 
> Wow, that was unnecessarily large.  Here's a smaller one...
> 
>      	      		    	    	     - Ted
> 

Was that by hand-hackery or did you figure out how to hit
it at runtime?

-Eric
