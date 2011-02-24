From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 17:41:31 -0700
Message-ID: <B80C0D24-033B-4B17-98C5-1645E3651FCD@dilger.ca>
References: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl> <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca> <20110223231739.GS2924@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57989 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1BXAlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 19:41:32 -0500
In-Reply-To: <20110223231739.GS2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-23, at 4:17 PM, Ted Ts'o wrote:
> On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:
>> 
>> If you have the opportunity, I wonder whether the entire need for
>> tdb can be avoided in your case by using swap and the icount
>> optimization patches previously posted?  
> 
> Unfortunately, there are people who are still using 32-bit CPU's, so
> no, swap is not a solution here.

I agree it isn't a solution in all cases, but avoiding GB-sized realloc() in the code was certainly enough to fix problems for the original people who hit them.  It likely also avoids a lot of memcpy() (depending on how realloc is implemented).

Cheers, Andreas





