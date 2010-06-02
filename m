From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: e4defrag and immutable files
Date: Wed, 02 Jun 2010 00:28:59 -0700
Message-ID: <4C06083B.7050102@zytor.com>
References: <4C002427.3010706@zytor.com> <4C05604D.2070401@oracle.com> <20100601194924.GF4426@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	linux-ext4@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0FBH3R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jun 2010 03:29:17 -0400
In-Reply-To: <20100601194924.GF4426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2010 12:49 PM, tytso@mit.edu wrote:
> On Tue, Jun 01, 2010 at 12:32:29PM -0700, Sunil Mushran wrote:
>>
>> We (ocfs2) are looking to add a new attribute to denote files that
>> have a fixed allocation on disk. But at the same time, allow writes
>> that do not change the allocation on disk. No truncating, extending,
>> filling holes, etc. We were thinking of calling it "Static" files.
>
> That's an interesting set of semantics, and it might make sense to
> conflate that with a local disk "don't move or defrag" the file
> option.  I'm not crazy with the name "static", since it could mean a
> number of other things in other contexts, but I admit I can't think of
> a better name.
>

For what it's worth, this sort of seems to be what one would expect if a 
file is *both* "fixed" and "immutable".

	-hpa

