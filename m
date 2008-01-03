From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: add minimal resize size option
Date: Thu, 03 Jan 2008 14:21:20 -0600
Message-ID: <477D43C0.5030607@redhat.com>
References: <20080102201659.GI31745@dhcp243-37.rdu.redhat.com> <20080103172101.GE30771@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYACUVm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2008 15:21:42 -0500
In-Reply-To: <20080103172101.GE30771@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Jan 02, 2008 at 03:16:59PM -0500, Josef Bacik wrote:
>> Hello,
>>
>> People wishing to make live usb disks and such are looking for a way
>> to get the minimum resize size for an ext fs in blocks so that they
>> can just resize their image to that size and do with it what they
>> will.  This patch adds that functionality, just pass -m option and
>> it calculates the minimum number of blocks the fs can be resized to.
> 
> Three comments.  Instead of using a new option, why not simply let
> resize2fs check to see if the optional parameter is something like
> "min" or "0"?

How about spitting out minimum size message whenever a too-small size is
specified; 0 would then of course always take no action, but simply
print the minimum.  For a size that's actually specified, but too small,
it'd still be useful I think, to say "XXXXX blocks is too small, minimum
size is YYYYY" ?

0 could be special-cased to not print the "0 blocks is too small" part
(or whatever...)

-Eric
