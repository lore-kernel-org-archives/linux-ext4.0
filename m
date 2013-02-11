From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: use module parameters instead of debugfs for
 mballoc_debug
Date: Mon, 11 Feb 2013 10:04:20 -0600
Message-ID: <51191684.5080201@redhat.com>
References: <1360460534-818-1-git-send-email-tytso@mit.edu> <51191010.50402@redhat.com> <511912B1.9070407@redhat.com> <20130211155428.GA6001@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab3BKQE3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:04:29 -0500
In-Reply-To: <20130211155428.GA6001@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/11/13 9:54 AM, Theodore Ts'o wrote:
> On Mon, Feb 11, 2013 at 09:48:01AM -0600, Eric Sandeen wrote:
>>
>> As another thought, did you consider using dynamic debug for this, or is that
>> too much trickiness?  Might be nice since usually a bug reporter won't have
>> a kernel built with CONFIG_EXT4_DEBUG . . .
> 
> I had assumed that the long term direction was to use tracepoints,
> which also has the advantage of not requiring kernels built with
> CONFIG_EXT4_DEBUG.

I guess dynanmic debug wouldn't either, but yeah, tracepoints make
more sense I suppose.

> Hmm.... one thing though is if we want bug reporters to use
> tracepoints (as opposed to just developers), we'll need to have some
> pre-made shell scripts to make it easy for non-developers to enable
> tracepoints for various problems.

Yep the interface has always been a little clunky.  :)

Thanks,
-Eric

>      	 		   	  	      	  - Ted
> 

