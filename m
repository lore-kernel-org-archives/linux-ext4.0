From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH][e2fsprogs] add -E option to mke2fs usage information
Date: Tue, 16 Oct 2007 11:22:54 +0800
Message-ID: <47142E8E.2000105@suse.de>
References: <471376DF.5010705@suse.de> <20071015210049.GB18006@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37451 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbXJPDUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 23:20:33 -0400
In-Reply-To: <20071015210049.GB18006@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, Oct 15, 2007 at 10:19:11PM +0800, Coly Li wrote:
>> -E option is missed from usage information of mke2fs. This patch adds -E option to usage
>> information, and names -E|-R as extended-option.
>> Now the usage information can be consistent with mke2fs.8.in.
> 
> Please fill comments to 80 columns; thanks!!

I will follow this in future patches :-)
> 
> I checked this into the maint branch, but I just changed the message
> to use -E only.  The use of -R is deprecated, but supported for
> backwards compatibility; so there's no point putting it in the usage
> message.

Thanks for the message :-)
> 
> 							- Ted
