From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Tue, 09 Jul 2013 10:00:16 -0500
Message-ID: <51DC2580.8090706@redhat.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz> <51DC1AC5.8010809@redhat.com> <20130709143855.GF6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3GIPFd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 11:05:33 -0400
In-Reply-To: <20130709143855.GF6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/9/13 9:38 AM, Theodore Ts'o wrote:
> On Tue, Jul 09, 2013 at 09:14:29AM -0500, Eric Sandeen wrote:
>>
>> I don't think these did get cc'd to stable.  Was there a reason for that,
>> or was it an oversight?
> 
> It was an oversight; my fault, sorry.  I'll send a request to the
> stable kernel tree for the following patches:
> 
> 8af8eec ext4: fix overflow when counting used blocks on 32-bit architectures
> a60697f ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
> e7293fd ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
> eaf3793 ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
> 
> 	      	       	      	       	  	 - Ted

Thanks Ted!

-Eric

